1 pragma solidity ^0.4.23;
2 
3 contract T1WinTokenConfig {
4     /*=====================================
5     =            EVENT               =
6     =====================================*/
7     event addConfigUser(
8     address indexed userAddress,
9     uint ethereumReinvested
10     );
11      event addToken(
12     address indexed tokenAddress,
13     string tokenName
14     );
15      event removeToken(
16     address indexed tokenAddress,
17     string tokenName
18     );
19     /*=====================================
20     =            CONSTANTS               =
21     =====================================*/
22     T1WinAdmin constant private t1WinAdmin = T1WinAdmin(0xcc258f29443d849efd5dccf233bfe29533b042bc);
23 
24     uint constant internal  configEthSpent       = 1   ether;
25 
26     
27     address[] configUserList; 
28 
29     T1Wdatasets.TokenConfiguration[] public tokenListArray;
30     //token address -> token object map 
31     mapping (address => T1Wdatasets.TokenConfiguration) public tokenListMap;
32     //address -> add config user map  
33     mapping (address => T1Wdatasets.AddConfigurationUser) public configurationUserMap;
34     mapping (address => uint256) public configurationUserCheck;
35    address private adminAddress;
36     modifier onlyAuthorizedAdmin {
37         adminAddress=t1WinAdmin.getAdmin();
38         require(adminAddress == msg.sender);
39         _;
40     }
41     modifier isWithinETHLimits(uint256 _eth) {
42         // add a configuration need 1 ETH
43         require(_eth == 1000000000000000000);
44         _;    
45     }
46     //get token array lenght
47     function getTokenArrayLength() 
48         public
49         view
50         returns(uint) 
51     {
52         return tokenListArray.length;
53     }    
54     //get token from array
55     function getToken(uint n)
56         public 
57         view
58         returns (address, string,uint8,bool ) {
59         return (tokenListArray[n].tokenAddress, tokenListArray[n].tokenName,tokenListArray[n].tokenDecimals,tokenListArray[n].used);
60     }  
61     function getTokenByAddress(address a)
62         public 
63         view
64         returns (address, string,uint8,bool ) {
65         T1Wdatasets.TokenConfiguration token = tokenListMap[a];
66         return (token.tokenAddress, token.tokenName,token.tokenDecimals,token.used);
67     } 
68     function getTokenNameByAddress(address a)
69         public 
70         view
71         returns (string ) {
72              T1Wdatasets.TokenConfiguration token = tokenListMap[a];
73              return(token.tokenName);
74         }
75       function getTokenDecimalsByAddress(address a)
76         public 
77         view
78         returns (uint8 ) {
79              T1Wdatasets.TokenConfiguration token = tokenListMap[a];
80              return(token.tokenDecimals);
81         }   
82      //add new token by admin
83     function addNewTokenByAdmin(address _tokenAddress, string _tokenName,uint8 decimal)
84             onlyAuthorizedAdmin()
85             public
86         {
87             //check the token address already exist or not exit
88              require(!tokenListMap[_tokenAddress].used);
89              tokenListMap[_tokenAddress]= T1Wdatasets.TokenConfiguration(_tokenAddress, _tokenName,decimal,true);
90              tokenListArray.push(tokenListMap[_tokenAddress]);
91              emit addToken(_tokenAddress, _tokenName);
92         }
93      //remove token by admin    
94     function removeNewTokenByAdmin(address _tokenAddress)
95             onlyAuthorizedAdmin()
96             public
97         {
98             //remove from map
99             delete tokenListMap[_tokenAddress];
100             //remove from array 
101             for (uint i = 0; i < tokenListArray.length; i++) {
102                 if (tokenListArray[i].tokenAddress == _tokenAddress) {
103                     tokenListArray[i] = tokenListArray[tokenListArray.length - 1];
104                     tokenListArray.length -= 1;
105                     break;
106                 }
107             }
108           
109         }
110     function addNewToken(address _tokenAddress, bytes32 _tokenName)
111             isWithinETHLimits(msg.value)
112             public
113             payable
114         {
115           uint256 checkUserStatu = configurationUserCheck[msg.sender];
116             //1 . chcke if the address already existin the config address array
117             
118             if(checkUserStatu == 0){
119                 //this is new user, change the user statu to 1.
120                 configurationUserCheck[msg.sender]=1;
121                 // inital a  new configuration user
122                 T1Wdatasets.AddConfigurationUser memory configurationUser ; 
123                 configurationUser.addr = msg.sender;
124                 configurationUser.ethTotalAmount += msg.value;
125                 configurationUserMap[msg.sender] = configurationUser;
126                 emit addConfigUser(msg.sender , msg.value);
127                
128             }
129     
130             //2. add new Token
131             
132               
133         }
134 
135 }
136 
137 /*================================
138 =            Interface            =
139 ================================*/
140 
141 interface T1WinAdmin {
142     function getAdmin() external view returns(address);
143 }
144 /*================================
145 =            DATASETS            =
146 ================================*/
147 library T1Wdatasets {
148 
149     struct TokenConfiguration{
150         address tokenAddress; //round play token address
151         string tokenName;  //round play token name 
152         uint8 tokenDecimals; //Token decimals
153         bool used;
154       
155     }
156     
157     
158     
159     /*
160      * What address can work with this configuration
161      */
162     struct AddConfigurationUser {
163         address addr;   // player address
164         uint256 ethTotalAmount; //eth total amount
165         bool used;
166     }
167   
168     
169 }