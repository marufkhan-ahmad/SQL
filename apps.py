import pandas as pd
import warnings
warnings.filterwarnings('ignore')
import streamlit as st

class ConversionFunnel:
    """A class to handle conversion funnel analysis for affiliate marketing data.

    Attributes:
        df (pd.DataFrame): Stores the processed dataset.
        file_path (str): Path to the uploaded CSV file.
    """


    def __init__(self, file_path=None):
        """Initialize the ConversionFunnel class with an optional file path.

        Args:
            file_path (str, optional): Path to the CSV file. Defaults to None.
        """
        self.df = None
        self.file_path = file_path


    def process_data(self):
        """Process the uploaded CSV file and prepare the dataset.

        Handles datetime conversion, missing values, and derives new columns.
        Returns:
            pd.DataFrame: Processed dataframe or None if an error occurs.
        """
        try:
            if self.file_path is None:
                return None
            
            self.df = pd.read_csv(self.file_path)
            self.df['click_time'] = pd.to_datetime(self.df['click_time'], errors='coerce')
            self.df['conversion_time'] = pd.to_datetime(self.df['conversion_time'], errors='coerce')
            self.df['conversion_lag_minutes'] = (self.df['conversion_time'] - self.df['click_time']).dt.total_seconds() / 60
            self.df['conversion_status'] = self.df['conversion_status'].str.lower().fillna("unknown")
            self.df['is_converted'] = self.df['conversion_status'] == 'approved'
            self.df['is_clicked'] = self.df['click_time'].notnull()
            return self.df
        except Exception as e:
            st.error(f"Error processing data: {e}")
            return None
        

    def get_overview_metrics(self):
        """Calculate overview metrics for the conversion funnel.

        Returns:
            tuple: (total_clicks, total_conversions, conversion_rate, avg_lag) or None if error.
        """
        try:
            total_clicks = self.df['is_clicked'].sum()
            total_conversions = self.df['is_converted'].sum()
            conversion_rate = total_conversions / total_clicks if total_clicks else 0
            avg_lag = self.df[self.df['is_converted']]['conversion_lag_minutes'].mean()
            return total_clicks, total_conversions, conversion_rate, avg_lag
        except Exception as e:
            st.error(f"Error calculating metrics: {e}")
            return None
        

    def get_traffic_summary(self):
        """Generate a summary of traffic sources based on conversion metrics.

        Returns:
            pd.DataFrame: Aggregated data sorted by conversion rate or None if error.
        """
        try:
            return self.df.groupby('ref_traffic_source').agg(
                total_clicks=('is_clicked', 'sum'),
                approved_conversions=('is_converted', 'sum'),
                conversion_rate=('is_converted', lambda x: x.sum() / x.count() if x.count() > 0 else 0),
                avg_lag=('conversion_lag_minutes', 'mean')
            ).sort_values(by='conversion_rate', ascending=False)
        except Exception as e:
            st.error(f"Error generating traffic summary: {e}")
            return None
        

    def get_drop_off_summary(self):
        """Generate a drop-off analysis summary by traffic source.

        Returns:
            pd.DataFrame: Summary with drop-off rate or None if error.
        """
        try:
            drop_off_summary = self.df.groupby('ref_traffic_source').agg(
                total_clicks=('is_clicked', 'sum'),
                total_conversions=('is_converted', 'sum')
            ).reset_index()
            drop_off_summary['drop_off'] = drop_off_summary['total_clicks'] - drop_off_summary['total_conversions']
            drop_off_summary['drop_off_rate'] = drop_off_summary['drop_off'] / drop_off_summary['total_clicks']
            return drop_off_summary.sort_values(by='drop_off_rate', ascending=False)
        except Exception as e:
            st.error(f"Error generating drop-off summary: {e}")
            return None
        


    def get_lag_by_source(self):
        """Calculate average conversion lag by traffic source for converted users.

        Returns:
            pd.DataFrame: DataFrame with average lag or None if error.
        """
        try:
            lag_series = self.df[self.df['is_converted']].groupby('ref_traffic_source')['conversion_lag_minutes'].mean()
            return lag_series.reset_index(name='average_lag_minutes').sort_values(by='average_lag_minutes')
        except Exception as e:
            st.error(f"Error calculating lag by source: {e}")
            return None
        


    def get_campaign_summary(self):
        """Generate a summary of campaign performance metrics.

        Returns:
            pd.DataFrame: Top 10 campaigns sorted by conversion rate or None if error.
        """
        try:
            return self.df.groupby('campaign_id').agg(
                total_clicks=('is_clicked', 'sum'),
                conversions=('is_converted', 'sum'),
                conv_rate=('is_converted', lambda x: x.sum() / x.count()),
                avg_lag=('conversion_lag_minutes', 'mean')
            ).sort_values(by='conv_rate', ascending=False).head(10)
        except Exception as e:
            st.error(f"Error generating campaign summary: {e}")
            return None

# Improved CSS function
def apply_custom_css():
    """
       Apply custom CSS to enhance responsiveness of the Streamlit app.
       Adjusts layout and styling for different screen sizes.

    """
    try:
        st.markdown("""
            <style>
            .stApp {
                max-width: 100%;
                margin: 0 auto;
                padding: 10px;
            }
            .css-1aumxhk, .st-emotion-cache-1aumxhk {
                max-width: 100% !important;
                padding: 10px;
            }
            .st-emotion-cache-1v0mbdj, .css-1v0mbdj {
                padding: 5px;
            }
            .stDataFrame {
                width: 100% !important;
                overflow-x: auto;
            }
            @media (max-width: 768px) {
                .stApp {
                    padding: 5px;
                }
                .css-1aumxhk, .st-emotion-cache-1aumxhk {
                    padding: 5px;
                }
                .st-emotion-cache-1v0mbdj, .css-1v0mbdj {
                    padding: 2px;
                }
                .stDataFrame {
                    font-size: 12px;
                }
            }
            </style>
        """, unsafe_allow_html=True)
        
    except Exception as e:
        st.error(f"Error applying CSS: {e}")