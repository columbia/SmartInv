1 pragma solidity ^0.4.20;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require (msg.sender == owner) ;
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public{
16         owner = newOwner;
17     }
18 }
19 
20 
21 
22 
23 /// @title Hive Chain Coin (HIVE)
24 contract HiveChainToken is owned {
25     // Public variables of the token
26     string public constant standard = "ERC20";
27     string public constant name = "Hive Chain Coin";  
28     string public constant symbol = "HIVE";
29     uint8  public constant decimals =18;
30     uint256 public constant totalSupply=3000000000*10 ** uint256(decimals);
31     uint public allcatedTime = 0;
32  
33     address  public constant teamAddress = 0x95EEe45FFef756D8bfce8D8Ad1617c331A6d0CbB;
34                                             
35     
36     address  public constant counselorAddress = 0x067AA439831C0E6070Aaf0Ba2c6c6EC4bb4c9D09;
37     
38     address  public constant footstoneAddress = 0xe1461098D05c8d30aACb8Db6E3c10F9aCE80319A;
39 
40     // This creates an array with all balanceOf 
41     mapping (address => uint256) public balanceOf;
42  
43    
44     // These are related to HC team members
45     mapping (address => bool) public frozenAccount;
46  
47 		// This creates an array with all lockedTokens 
48     mapping (address => frozenTeam[]) public lockedTokens;
49     
50     
51    
52 		// Triggered when tokens are transferred.
53     event Transfer(address indexed _from, address indexed _to, uint256 _value);
54 
55     struct frozenTeam{       
56         uint256 time;
57         uint256 token;    
58     }
59 
60     // Constructor 
61     function HiveChainToken()  public
62     {
63        
64         balanceOf[0x065cCc2Ed012925f428643df16AA9395a1e5c664] = totalSupply*116/300; 
65         
66         balanceOf[msg.sender]=totalSupply/3;
67         
68         //team
69         
70         balanceOf[teamAddress] = totalSupply*15/100; // 15% 
71             
72         allcatedTime=now;
73         
74         frozenAccount[teamAddress]=true;
75          for (uint i = 0; i < 19; i++) {
76              uint256 temp0=balanceOf[teamAddress]*(i+1)*5/100;
77              lockedTokens[teamAddress].push(frozenTeam({
78                  time:allcatedTime + 3*(i+1) * 30 days ,
79                  token:balanceOf[teamAddress]-temp0
80              }));
81             
82          }
83         
84         
85        balanceOf[counselorAddress] = totalSupply*3/100; // 3% 
86        
87        frozenAccount[counselorAddress]=true;
88             for (uint j = 0; j < 5; j++){
89                  uint256 temp;
90                  if(j==0){
91                      temp=balanceOf[counselorAddress]*80/100;
92                  }else if(j==1){
93                      temp=balanceOf[counselorAddress]*65/100;
94                  }else if(j==2){
95                      temp=balanceOf[counselorAddress]*50/100;
96                  }else if(j==3){
97                      temp=balanceOf[counselorAddress]*30/100;
98                  }else if(j==4){
99                       temp=balanceOf[counselorAddress]*15/100;
100                  }
101                  lockedTokens[counselorAddress].push(frozenTeam({
102                  time:allcatedTime + (j+1) * 30 days ,
103                  token:temp
104              }));
105             }
106         
107        
108         
109         balanceOf[footstoneAddress] = totalSupply*10/100; // 10% 
110       
111        
112        frozenAccount[footstoneAddress]=true;
113             for (uint k = 0; k < 5; k++){
114                  uint256 temp1;
115                    if(k==0){
116                      temp1=balanceOf[footstoneAddress]*80/100;
117                  }else if(k==1){
118                      temp1=balanceOf[footstoneAddress]*65/100;
119                  }else if(k==2){
120                      temp1=balanceOf[footstoneAddress]*50/100;
121                  }else if(k==3){
122                      temp1=balanceOf[footstoneAddress]*30/100;
123                  }else if(k==4){
124                       temp1=balanceOf[footstoneAddress]*15/100;
125                  }
126                  lockedTokens[footstoneAddress].push(frozenTeam({
127                  time:allcatedTime + (k+1) * 30 days ,
128                  token:temp1
129              }));
130             }
131         
132                             
133     }
134   
135 
136 
137     // Transfer the balance from owner"s account to another account
138     function transfer(address _to, uint256 _amount) public
139         returns (bool success) 
140     {
141   
142         if (_amount <= 0) return false;
143       
144         if (frozenRules(msg.sender, _amount)) return false;
145 
146         if (balanceOf[msg.sender] >= _amount
147             && balanceOf[_to] + _amount > balanceOf[_to]) {
148 
149             balanceOf[msg.sender] -= _amount;
150             balanceOf[_to] += _amount;
151             Transfer(msg.sender, _to, _amount);
152             return true;
153         } else {
154             return false;
155         }     
156     }
157  
158 
159 
160     /// @dev Token frozen rules for token holders.
161     /// @param _from The token sender.
162     /// @param _value The token amount.
163     function frozenRules(address _from, uint256 _value) 
164         internal 
165         returns (bool success) 
166     {
167         if (frozenAccount[_from]) {
168             
169             frozenTeam[] storage lockedInfo=lockedTokens[_from];
170             for(uint256 i=0;i<lockedInfo.length;i++){
171                 if (now <lockedInfo[i].time) {
172                    // 100% locked within the first 6 months.
173                         if (balanceOf[_from] - _value < lockedInfo[i].token)
174                             return true;  
175                  }else if (now >=lockedInfo[i].time && now < lockedInfo[i+1].time) {
176                      // 20% unlocked after 6 months.
177                         if (balanceOf[_from] - _value <lockedInfo[i+1].token) 
178                             return true;  
179                  }else if(now>=lockedInfo[lockedInfo.length-1].time){
180                       frozenAccount[_from] = false; 
181                       return false;
182                  }
183             }
184             
185         }
186         return false;
187     }   
188 }