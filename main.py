import streamlit as st
from app import ConversionFunnel, apply_custom_css

def main():
    """Main function to run the Conversion Funnel Insights Streamlit app.

    Sets up the UI, handles file upload, and displays analytics.
    """
    # Page setup
    st.set_page_config(page_title="Conversion Funnel Insights", layout="wide")
    st.title("✅ Conversion Funnel Insights & Recommendations")

    # Apply custom CSS for responsiveness
    apply_custom_css()

    # Upload CSV file
    uploaded_file = st.file_uploader("Upload your affiliate CSV file", type=["csv"])

    if uploaded_file:
        # Initialize and process data
        funnel = ConversionFunnel(uploaded_file)
        funnel.process_data()

        st.header("📊 Overview Metrics")
        total_clicks, total_conversions, conversion_rate, avg_lag = funnel.get_overview_metrics()
        col1, col2, col3, col4 = st.columns([1, 1, 1, 1])  # Equal width columns
        col1.metric("Total Clicks", f"{total_clicks}")
        col2.metric("Total Conversions", f"{total_conversions}")
        col3.metric("Conversion Rate", f"{conversion_rate:.2%}")
        col4.metric("Avg. Lag (min)", f"{avg_lag:.1f}")

        st.header("🚦 Best Traffic Sources")
        traffic_summary = funnel.get_traffic_summary()
        st.dataframe(traffic_summary.style.set_properties(**{'width': '100%'}), use_container_width=True)

        st.header("📉 Drop-off Analysis")
        drop_off_summary = funnel.get_drop_off_summary()
        st.dataframe(drop_off_summary.style.set_properties(**{'width': '100%'}), use_container_width=True)

        st.header("⏱️ Optimize Conversion Lag")
        lag_by_source = funnel.get_lag_by_source()
        st.dataframe(lag_by_source.style.set_properties(**{'width': '100%'}), use_container_width=True)

        st.header("🎯 Campaign Strategy Suggestions")
        campaign_summary = funnel.get_campaign_summary()
        st.dataframe(campaign_summary.style.set_properties(**{'width': '100%'}), use_container_width=True)

        st.markdown("""
        ### 🧠 Key Recommendations:
        - **Boost** top-performing traffic sources with high conversion rate and low lag.
        - **Review** sources with high clicks but poor conversion (likely drop-offs).
        - **Retarget** users from high-lag sources with reminder emails or urgency.
        - **Pause or revise** underperforming campaigns with poor conversion metrics.
        """)

    else:
        st.info("👆 Upload your CSV file to start analysis.")

if __name__ == "__main__":
    main()