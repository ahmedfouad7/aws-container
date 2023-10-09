import streamlit as st 


st.set_page_config( initial_sidebar_state="collapsed",
    page_title="Adva",
    page_icon="👋",
    layout='wide' 
    )

st.markdown(
    """
<style>
    [data-testid="collapsedControl"]{
        display: none
    }
</style>
""",
    unsafe_allow_html=True,
)

parameters = st.experimental_get_query_params()
 

st.write("# Welcome to Streamlit! 👋")

# st.sidebar.success("Select a demo above.")
st.markdown(
    f"""
  ## Medical Procedures on Flexible Installments

**Pay on flexible installment plans for any surgical operation or medical procedure with ADVA. Choose from a wide network of doctors, clinics & hospitals to book your medical procedure on flexible installments up to 24 months and with the lowest interest price. Pay your operation expenses for up to 60 months.**
"""
)
