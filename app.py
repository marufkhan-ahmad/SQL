import streamlit as st
import google.generativeai as genai
from dotenv import load_dotenv
import os

# Load environment variables from .env
load_dotenv()

# Get API key from environment variable
API_KEY = os.getenv("GOOGLE_API_KEY")

# Configure the Gemini API
genai.configure(api_key=API_KEY)

# Chatbot class
class GeminiChatBot:
    def __init__(self, model_name="gemini-1.5-pro-001"):
        self.model = genai.GenerativeModel(model_name)
        self.chat = self.model.start_chat()

    def send_message(self, message):
        self.chat.send_message(message)
        return self.chat.last.text

    def get_history(self):
        history = []
        for msg in self.chat.history:
            role = "You" if msg.role == "user" else "Gemini"
            text = msg.parts[0].text
            history.append((role, text))
        return history

# Streamlit UI
st.set_page_config(page_title="Gemini Chatbot")
st.title("💬 Gemini 1.5 Pro Chatbot")

# Initialize chatbot once in session state
if "bot" not in st.session_state:
    st.session_state.bot = GeminiChatBot()

# Chat input box
user_input = st.chat_input("Say something to Gemini...")

# Process user input
if user_input:
    st.chat_message("You").write(user_input)
    response = st.session_state.bot.send_message(user_input)
    st.chat_message("Gemini").write(response)

# Display chat history
for role, msg in st.session_state.bot.get_history():
    st.markdown(f"**{role}:** {msg}")
