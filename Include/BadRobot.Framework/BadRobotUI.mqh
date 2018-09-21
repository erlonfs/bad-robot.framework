//+------------------------------------------------------------------+
//|                                   Copyright 2018, Erlon F. Souza |
//|                                       https://github.com/erlonfs |
//+------------------------------------------------------------------+

#property copyright "Copyright 2018, Erlon F. Souza"
#property link      "https://github.com/erlonfs"
#property version    "1.0"

#include <Controls\Dialog.mqh>
#include <Controls\Button.mqh>
#include <Controls\Edit.mqh>
#include <Controls\Label.mqh>
#include <Controls\DatePicker.mqh>
#include <Controls\ListView.mqh>
#include <Controls\ComboBox.mqh>
#include <Controls\SpinEdit.mqh>
#include <Controls\RadioGroup.mqh>
#include <Controls\CheckGroup.mqh>

#include <BadRobot.Framework\Logger.mqh>
#include <BadRobot.Framework\BadRobotCore.mqh>

//--- indents and gaps
#define INDENT_LEFT                         (11)      // indent from left (with allowance for border width)
#define INDENT_TOP                          (11)      // indent from top (with allowance for border width)
#define INDENT_RIGHT                        (11)      // indent from right (with allowance for border width)
#define INDENT_BOTTOM                       (11)      // indent from bottom (with allowance for border width)
#define CONTROLS_GAP_X                      (5)       // gap by X coordinate
#define CONTROLS_GAP_Y                      (5)       // gap by Y coordinate
//--- for buttons
#define BUTTON_WIDTH                        (80)     // size by X coordinate
#define BUTTON_HEIGHT                       (20)      // size by Y coordinate
//--- for the indication area
#define EDIT_HEIGHT                         (20)      // size by Y coordinate
//--- for group controls
#define GROUP_WIDTH                         (150)     // size by X coordinate
#define LIST_HEIGHT                         (179)     // size by Y coordinate
#define RADIO_HEIGHT                        (56)      // size by Y coordinate
#define CHECK_HEIGHT                        (93)      // size by Y coordinate

#define PANEL_WIDTH                         (300)      // width of panel
#define PANEL_HEIGHT                        (300)      // height of panel

class BadRobotUI  : public BadRobotCore
{
	private:
		
	CEdit             m_edit;                         
   CButton           btnComprar;                       
   CButton           btnVender; 
   CLabel            m_label_1;
   CLabel            m_label_2;
   CLabel            m_label_3;

   CButton           m_button3;                       // the fixed button object
   CSpinEdit         m_spin_edit;                     // the up-down object
   CDatePicker       m_date;                          // the datepicker object
   CListView         m_list_view;                     // the list object
   CComboBox         m_combo_box;                     // the dropdown list object
   CRadioGroup       m_radio_group;                   // the radio buttons group object
   CCheckGroup       m_check_group;                   // the check box group object
	
	bool CreateBtnComprar(void)
   {
      int x1=INDENT_LEFT;
      int y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y);
      int x2=x1+BUTTON_WIDTH;
      int y2=y1+BUTTON_HEIGHT;

      if(!btnComprar.Create(m_chart_id,m_name+"BtnComprar",m_subwin,x1,y1,x2,y2))
         return(false);
      if(!btnComprar.Text("Comprar"))
         return(false);
      if(!Add(btnComprar))
         return(false);

      return(true);
    }
    
    
   bool CreateBtnVender(void)
   {
      int x1=INDENT_LEFT+(BUTTON_WIDTH+CONTROLS_GAP_X);
      int y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y);
      int x2=x1+BUTTON_WIDTH;
      int y2=y1+BUTTON_HEIGHT;
   
      if(!btnVender.Create(m_chart_id,m_name+"BtnVender",m_subwin,x1,y1,x2,y2))
         return(false);
      if(!btnVender.Text("Vender"))
         return(false);
      if(!Add(btnVender))
         return(false);
   
      return(true);
   }
	
	bool CreateLabel1(void) 
   { 
      int x1=5;
      int y1= PANEL_HEIGHT - 122;
      int x2=x1+BUTTON_WIDTH;
      int y2=y1+BUTTON_HEIGHT;
      
      //_logger.Log("x1=" + x1 + " x2=" + x2 + " y1=" + y1 + " y2="+ y2);

      if(!m_label_1.Create(m_chart_id,m_name+"Label1",m_subwin,x1,y1,x2,y2)) return(false); 
      
      m_label_1.FontSize(8);
      
      if(!Add(m_label_1)) return(false); 
      
      

      return(true); 
   } 
   
   bool CreateLabel2(void) 
   { 
      int x1=5;
      int y1= PANEL_HEIGHT - 110;
      int x2=x1+BUTTON_WIDTH;
      int y2=y1+BUTTON_HEIGHT;
      
      //_logger.Log("x1=" + x1 + " x2=" + x2 + " y1=" + y1 + " y2="+ y2);

      if(!m_label_2.Create(m_chart_id,m_name+"Label2",m_subwin,x1,y1,x2,y2)) return(false); 
      
      m_label_2.FontSize(8);
      
      if(!Add(m_label_2)) return(false); 
      
      

      return(true); 
   } 
   
   bool CreateLabel3(void) 
   { 
      int x1=5;
      int y1= PANEL_HEIGHT - 98;
      int x2=x1+BUTTON_WIDTH;
      int y2=y1+BUTTON_HEIGHT;
      
      //_logger.Log("x1=" + x1 + " x2=" + x2 + " y1=" + y1 + " y2="+ y2);

      if(!m_label_3.Create(m_chart_id,m_name+"Label3",m_subwin,x1,y1,x2,y2)) return(false); 
      
      m_label_3.FontSize(8);
      
      if(!Add(m_label_3)) return(false); 
      
      

      return(true); 
   } 
	
	protected:
	
   EVENT_MAP_BEGIN(BadRobotUI)
      ON_EVENT(ON_CLICK,btnComprar,OnClickBtnComprar)
      ON_EVENT(ON_CLICK,btnVender,OnClickBtnVender)
      /*ON_EVENT(ON_CLICK,m_button3,OnClickButton3)
      ON_EVENT(ON_CHANGE,m_spin_edit,OnChangeSpinEdit)
      ON_EVENT(ON_CHANGE,m_date,OnChangeDate)
      ON_EVENT(ON_CHANGE,m_list_view,OnChangeListView)
      ON_EVENT(ON_CHANGE,m_combo_box,OnChangeComboBox)
      ON_EVENT(ON_CHANGE,m_radio_group,OnChangeRadioGroup)
      ON_EVENT(ON_CHANGE,m_check_group,OnChangeCheckGroup)*/
   EVENT_MAP_END(CAppDialog)
		
		
	public:
	
	
	
		BadRobotUI()
		{
         Load();
		}			
		
		~BadRobotUI()
		{
		   CAppDialog::Destroy(0);
		}	
		
		bool Load()
		{
		   if(!CAppDialog::Create(0, _robotName + " BadRobot " + version, 0, 3, 50, PANEL_WIDTH, PANEL_HEIGHT))return(false);		
		      
		   if(!CreateBtnComprar())return(false);
		   if(!CreateBtnVender())return(false);	  
		   if(!CreateLabel1())return(false);	  
		   if(!CreateLabel2())return(false);	  
		   if(!CreateLabel3())return(false);	  
		   
		   CAppDialog::Run();
		   
         return (true);
		}
		
		void OnClickBtnComprar()
      {         
         BadRobotCore::Buy();         
      }
		
		void OnClickBtnVender()
      {         
         BadRobotCore::Sell();         
      }	
      
      void ShowInfo()
      {
         m_label_1.Text(_logger.Get(0));
         m_label_2.Text(_logger.Get(1));
         m_label_3.Text(_logger.Get(2));
      }	
	
};