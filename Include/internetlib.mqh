//+------------------------------------------------------------------+
//|															 				InetHttp |
//|                                    Copyright © 2010, FXmaster.de |
//|                                						  www.FXmaster.de |
//|     programming & support - Alexey Sergeev (profy.mql@gmail.com) |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, FXmaster.de"
#property link      "www.FXmaster.de"
#property version		"1.00"
#property description  "WinHttp & WinInet API"
#property library

#define FALSE 0

#define HINTERNET int
#define BOOL int
#define INTERNET_PORT int
#define LPINTERNET_BUFFERS int
#define DWORD int
#define DWORD_PTR int
#define LPDWORD int&
#define LPVOID uchar& 
#define LPSTR string
#define LPCWSTR	string&
#define LPCTSTR string&
#define LPTSTR string&
//LPCTSTR *		int
//LPVOID			uchar& +_[]

#import	"Kernel32.dll"
	DWORD GetLastError(int);
#import

#import "wininet.dll"
	DWORD InternetAttemptConnect(DWORD dwReserved);
	HINTERNET InternetOpenW(LPCTSTR lpszAgent, DWORD dwAccessType, LPCTSTR lpszProxyName, LPCTSTR lpszProxyBypass, DWORD dwFlags);
	HINTERNET InternetConnectW(HINTERNET hInternet, LPCTSTR lpszServerName, INTERNET_PORT nServerPort, LPCTSTR lpszUsername, LPCTSTR lpszPassword, DWORD dwService, DWORD dwFlags, DWORD_PTR dwContext);
	HINTERNET HttpOpenRequestW(HINTERNET hConnect, LPCTSTR lpszVerb, LPCTSTR lpszObjectName, LPCTSTR lpszVersion, LPCTSTR lpszReferer, int /*LPCTSTR* */ lplpszAcceptTypes, uint/*DWORD*/ dwFlags, DWORD_PTR dwContext);
	BOOL HttpSendRequestW(HINTERNET hRequest, LPCTSTR lpszHeaders, DWORD dwHeadersLength, LPVOID lpOptional[], DWORD dwOptionalLength);
	BOOL HttpQueryInfoW(HINTERNET hRequest, DWORD dwInfoLevel, LPVOID lpvBuffer[], LPDWORD lpdwBufferLength, LPDWORD lpdwIndex);
	HINTERNET InternetOpenUrlW(HINTERNET hInternet, LPCTSTR lpszUrl, LPCTSTR lpszHeaders, DWORD dwHeadersLength, uint/*DWORD*/ dwFlags, DWORD_PTR dwContext);
	BOOL InternetReadFile(HINTERNET hFile, LPVOID lpBuffer[], DWORD dwNumberOfBytesToRead, LPDWORD lpdwNumberOfBytesRead);
	BOOL InternetCloseHandle(HINTERNET hInternet);
	BOOL InternetSetOptionW(HINTERNET hInternet, DWORD dwOption, LPDWORD lpBuffer, DWORD dwBufferLength);
	BOOL InternetQueryOptionW(HINTERNET hInternet, DWORD dwOption, LPDWORD lpBuffer, LPDWORD lpdwBufferLength);
//	BOOL InternetSetCookieW(LPCTSTR lpszUrl, LPCTSTR lpszCookieName, LPCTSTR lpszCookieData);
	BOOL InternetGetCookieW(LPCTSTR lpszUrl, LPCTSTR lpszCookieName, LPVOID lpszCookieData[], LPDWORD lpdwSize);
#import

#define OPEN_TYPE_PRECONFIG		0   // use default configuration
#define INTERNET_SERVICE_FTP						1 // Ftp service
#define INTERNET_SERVICE_HTTP						3	// Http service 
#define HTTP_QUERY_CONTENT_LENGTH 			5

#define INTERNET_FLAG_PRAGMA_NOCACHE						0x00000100  // no caching of page
#define INTERNET_FLAG_KEEP_CONNECTION						0x00400000  // keep connection
#define INTERNET_FLAG_SECURE            				0x00800000
#define INTERNET_FLAG_RELOAD										0x80000000  // get page from server when calling it
#define INTERNET_OPTION_SECURITY_FLAGS    	     31

#define ERROR_INTERNET_INVALID_CA								12045
#define INTERNET_FLAG_IGNORE_CERT_DATE_INVALID  0x00002000
#define INTERNET_FLAG_IGNORE_CERT_CN_INVALID    0x00001000
#define SECURITY_FLAG_IGNORE_CERT_CN_INVALID    INTERNET_FLAG_IGNORE_CERT_CN_INVALID
#define SECURITY_FLAG_IGNORE_CERT_DATE_INVALID  INTERNET_FLAG_IGNORE_CERT_DATE_INVALID
#define SECURITY_FLAG_IGNORE_UNKNOWN_CA         0x00000100
#define SECURITY_FLAG_IGNORE_WRONG_USAGE        0x00000200

//------------------------------------------------------------------ struct tagRequest
struct tagRequest
{
	string stVerb; // method of the GET/POST request
	string stObject; // path to the page "/get.php?a=1" or "/index.htm"
	string stHead; // request header, 
								// "Content-Type: multipart/form-data; boundary=1BEF0A57BE110FD467A\r\n"
								// or "Content-Type: application/x-www-form-urlencoded"
	string stData; // additional string of information
	bool fromFile; // if =true, then stData is the name of the data file
	string stOut; // field for receiving the answer
	bool toFile; // if =true, then stOut is the name of file for receiving the answer
	void Init(string aVerb, string aObject, string aHead, string aData, bool from, string aOut, bool to);
};
//------------------------------------------------------------------ class MqlNet
void tagRequest::Init(string aVerb, string aObject, string aHead, string aData, bool from, string aOut, bool to)
{
	stVerb=aVerb; // method of the GET/POST request
	stObject=aObject; // path to the page "/get.php?a=1" or "/index.htm"
	stHead=aHead; // request header, "Content-Type: application/x-www-form-urlencoded"
	stData=aData; // additional string of information
	fromFile=from; // if =true, then stData is the name of the data file
	stOut=aOut; // field for receiving the answer
	toFile=to; // if =true, then stOut is the name of file for receiving the answer
}
//------------------------------------------------------------------ class MqlNet
class MqlNet
{
public:
	string Host; // host name
	int Port; // port
	string User; // user name
	string Pass; // user password
	int Service; // service type 
	// obtained parameters
	int hSession; // session descriptor
	int hConnect; // connection descriptor
public:
	MqlNet(); // class constructor
	~MqlNet(); // destructor
	bool Open(string aHost, int aPort, string aUser, string aPass, int aService); // create a session and open a connection
	void Close(); // close the session and the connection
	bool Request(tagRequest &req); // send the request
	bool OpenURL(string aURL, string &Out, bool toFile); // just read the page to to a file or variable
	void ReadPage(int hRequest, string &Out, bool toFile); // read the page
	long GetContentSize(int hURL); //get information about the size of downloaded page
	int FileToArray(string FileName, uchar& data[]); // copy the file to the array for sending
};

//------------------------------------------------------------------ MqlNet
void MqlNet::MqlNet()
{
	hSession=-1; hConnect=-1; Host=""; User=""; Pass=""; Service=-1; // zeroize the parameters
}
//------------------------------------------------------------------ ~MqlNet
void MqlNet::~MqlNet()
{
	Close(); // close all descriptors 
}
//------------------------------------------------------------------ Open
bool MqlNet::Open(string aHost, int aPort, string aUser, string aPass, int aService)
{
	if (aHost=="") { Print("-Host not specified"); return(false); }
	if(!TerminalInfoInteger(TERMINAL_DLLS_ALLOWED)) { Print("-DLL not allowed"); return(false); } // checking whether DLLs are allowed in the terminal
	if(!MQL5InfoInteger(MQL5_DLLS_ALLOWED)) { Print("-DLL not allowed"); return(false); } // checking whether DLLs are allowed in the terminal
	if (hSession>0 || hConnect>0) Close(); // close if a session was determined 
	Print("+Open Inet..."); // print a message about the attempt of opening in the journal
	if (InternetAttemptConnect(0)!=0) { Print("-Err AttemptConnect"); return(false); } // exit if the attempt to check the current Internet connection failed
	string UserAgent="Mozilla"; string nill="";
	hSession=InternetOpenW(UserAgent, OPEN_TYPE_PRECONFIG, nill, nill, 0); // open session
	if (hSession<=0) { Print("-Err create Session"); Close(); return(false); } // exit if the attempt to open the session failed
	hConnect=InternetConnectW(hSession, aHost, aPort, aUser, aPass, aService, 0, 0); 
	if (hConnect<=0) { Print("-Err create Connect"); Close(); return(false); }
	Host=aHost; Port=aPort; User=aUser; Pass=aPass; Service=aService;
	return(true); // otherwise all the checks are successfully finished
}
//------------------------------------------------------------------ Close
void MqlNet::Close()
{
	if (hSession>0) { InternetCloseHandle(hSession); hSession=-1; Print("-Close Session..."); }
	if (hConnect>0) { InternetCloseHandle(hConnect); hConnect=-1; Print("-Close Connect..."); }
}
//------------------------------------------------------------------ Request
bool MqlNet::Request(tagRequest &req)
{
	if(!TerminalInfoInteger(TERMINAL_DLLS_ALLOWED)) { Print("-DLL not allowed"); return(false); } // checking whether DLLs are allowed in the terminal
	if(!MQL5InfoInteger(MQL5_DLLS_ALLOWED)) { Print("-DLL not allowed"); return(false); } // checking whether DLLs are allowed in the terminal
	if (req.toFile && req.stOut=="") { Print("-File not specified "); return(false); }
	uchar data[]; int hRequest, hSend; 
	string Vers="HTTP/1.1"; string nill="";
	if (req.fromFile) { if (FileToArray(req.stData, data)<0) { Print("-Err reading file "+req.stData); return(false); } }// reading file to the array
	else StringToCharArray(req.stData, data);

	if (hSession<=0 || hConnect<=0) { Close(); if (!Open(Host, Port, User, Pass, Service)) { Print("-Err Connect"); Close(); return(false); } }
	// creating descriptor of the request
	hRequest=HttpOpenRequestW(hConnect, req.stVerb, req.stObject, Vers, nill, 0, INTERNET_FLAG_KEEP_CONNECTION|INTERNET_FLAG_RELOAD|INTERNET_FLAG_PRAGMA_NOCACHE, 0); 
	if (hRequest<=0) { Print("-Err OpenRequest"); InternetCloseHandle(hConnect); return(false); }


	// sending the request
	int n=0;
	while (n<3)
	{
		n++;
		hSend=HttpSendRequestW(hRequest, req.stHead, StringLen(req.stHead), data, ArraySize(data)); // file is sent
		if (hSend<=0) 
		{ 	
			int err=0; err=GetLastError(err); Print("-Err SendRequest= ", err); 
			if (err!=ERROR_INTERNET_INVALID_CA)
			{
				int dwFlags;
				int dwBuffLen = sizeof(dwFlags);
				InternetQueryOptionW(hRequest, INTERNET_OPTION_SECURITY_FLAGS, dwFlags, dwBuffLen);
				dwFlags |= SECURITY_FLAG_IGNORE_UNKNOWN_CA;
				int rez=InternetSetOptionW(hRequest, INTERNET_OPTION_SECURITY_FLAGS, dwFlags, sizeof (dwFlags));
				if (!rez) { Print("-Err InternetSetOptionW= ", GetLastError(err)); break; }
			}
			else break;
		} 
		else break;
	}
	if (hSend>0) ReadPage(hRequest, req.stOut, req.toFile); // read the page
	InternetCloseHandle(hRequest); InternetCloseHandle(hSend); // close all handles
	if (hSend<=0) Close();
	return(true);
}
//------------------------------------------------------------------ OpenURL
bool MqlNet::OpenURL(string aURL, string &Out, bool toFile)
{
	if(!TerminalInfoInteger(TERMINAL_DLLS_ALLOWED)) { Print("-DLL not allowed"); return(false); } // checking whether DLLs are allowed in the terminal
	if(!MQL5InfoInteger(MQL5_DLLS_ALLOWED)) { Print("-DLL not allowed"); return(false); } // checking whether DLLs are allowed in the terminal
	string nill="";
	if (hSession<=0 || hConnect<=0) { Close(); if (!Open(Host, Port, User, Pass, Service)) { Print("-Err Connect"); Close(); return(false); } }
	int hURL=InternetOpenUrlW(hSession, aURL, nill, 0, INTERNET_FLAG_RELOAD|INTERNET_FLAG_PRAGMA_NOCACHE, 0); 
	if(hURL<=0) { Print("-Err OpenUrl"); return(false); }
	ReadPage(hURL, Out, toFile); // read in Out
	InternetCloseHandle(hURL); // close 
	return(true);
}
//------------------------------------------------------------------ ReadPage
void MqlNet::ReadPage(int hRequest, string &Out, bool toFile)
{
	if(!TerminalInfoInteger(TERMINAL_DLLS_ALLOWED)) { Print("-DLL not allowed"); return; } // checking whether DLLs are allowed in the terminal
	if(!MQL5InfoInteger(MQL5_DLLS_ALLOWED)) { Print("-DLL not allowed"); return; } // checking whether DLLs are allowed in the terminal
	// read the page 
	uchar ch[100]; string toStr=""; int dwBytes, h=-1;
	if (toFile) h=FileOpen(Out, FILE_ANSI|FILE_BIN|FILE_WRITE);
	while(InternetReadFile(hRequest, ch, 100, dwBytes)) 
	{
		if (dwBytes<=0) break; toStr=toStr+CharArrayToString(ch, 0, dwBytes);
		if (toFile) for (int i=0; i<dwBytes; i++) FileWriteInteger(h, ch[i], CHAR_VALUE);
	}
	if (toFile) { FileFlush(h); FileClose(h); }
	else Out=toStr;
}
//------------------------------------------------------------------ GetContentSize
long MqlNet::GetContentSize(int hRequest)
{
	if(!TerminalInfoInteger(TERMINAL_DLLS_ALLOWED)) { Print("-DLL not allowed"); return(false); } // checking whether DLLs are allowed in the terminal
	if(!MQL5InfoInteger(MQL5_DLLS_ALLOWED)) { Print("-DLL not allowed"); return(false); } // checking whether DLLs are allowed in the terminal
	int len=2048, ind=0; uchar buf[2048];
	int Res=HttpQueryInfoW(hRequest, HTTP_QUERY_CONTENT_LENGTH, buf, len, ind);
	if (Res<=0) { Print("-Err QueryInfo"); return(-1); }

	string s=CharArrayToString(buf, 0, len);
	if (StringLen(s)<=0) return(0);
	return(StringToInteger(s));
}
//----------------------------------------------------- FileToArray
int MqlNet::FileToArray(string aFileName, uchar& data[])
{
	int h, i, size;	
	h=FileOpen(aFileName, FILE_ANSI|FILE_BIN|FILE_READ);	if (h<0) return(-1);
	FileSeek(h, 0, SEEK_SET);	
	size=(int)FileSize(h); ArrayResize(data, (int)size); 
	for (i=0; i<size; i++) data[i]=(uchar)FileReadInteger(h, CHAR_VALUE); 
	FileClose(h); return(size);
}