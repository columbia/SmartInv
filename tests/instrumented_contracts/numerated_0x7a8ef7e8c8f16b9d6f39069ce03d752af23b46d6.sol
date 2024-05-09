1 pragma solidity ^0.4.18;
2 
3 /*
4 created by Igor Stulenkov 
5 */
6 
7 contract OBS_V1{
8  
9 	address public owner; //Fabric owner
10     mapping(address => address)    public tokens2owners;        // tokens to owners    
11     mapping(address => address []) public owners2tokens;        // owners to tokens
12     mapping(address => address)    public tmpAddr2contractAddr; // tmp addr contract to contract
13     
14     //Event
15     event evntCreateContract(address _addrTmp,
16                              address _addrToken,
17                              address _owner,
18                              address _addrBroker,
19                              uint256 _supply,
20                              string   _name
21                             ); 
22     //Constructor
23 	function OBS_V1() public{
24 		owner = msg.sender;
25 	}
26     
27     //Create contract
28     function createContract (address _owner,
29                             address _addrTmp, 
30                             uint256 _supply,
31                             string   _name) public{
32         //Only fabric owner may create Token
33         if (owner != msg.sender) revert();
34 
35         //Create contract
36         address addrToken = new MyObs( _owner, _supply, _name, "", 0, msg.sender);
37 
38         //Save info for public
39         tokens2owners[addrToken]       = _owner;	
40 		owners2tokens[_owner].push(addrToken);
41         tmpAddr2contractAddr[_addrTmp] = addrToken;
42         
43         //Send event
44         evntCreateContract(_addrTmp, addrToken, _owner, msg.sender, _supply, _name); 
45     }    
46 }
47 
48 contract MyObs{ 
49 
50     //Addresses
51     address public addrOwner;           //addr official owner
52     address public addrFabricContract;  //addr fabric contract, that create this token
53     address public addrBroker;          //addr broker account, that may call transferFrom
54 
55     //Define token
56     string public  name;                //token name    ='T_N', example T_1,T_12,...etc
57     string public  symbol;              //token symbol  =''
58     uint8  public  decimals;            //token decimal = 0
59     uint256 public supply;              //token count
60 
61     //Balance of accounts
62     mapping (address => uint256) public balances; 
63 
64     //Events 
65     event Transfer(address indexed from, address indexed to, uint256 value);
66     event Approval(address indexed _owner, address indexed _spender, uint _value);
67     
68     //Initializes contract 
69     function MyObs( address _owner, uint256 _supply, string _name, string _symbol, uint8 _decimals, address _addrBroker) public{
70         if (_supply == 0) revert();
71         
72         //Set addresses
73         addrOwner          = _owner;      //addr official owner
74         addrFabricContract = msg.sender;  //addr fabric contract
75         addrBroker         = _addrBroker; //addr broker account, that may call transferFrom
76 
77         //Owner get all tokens
78         balances[_owner]   = _supply;
79 
80         //Define token
81         name     = _name;     
82         symbol   = _symbol;
83         decimals = _decimals;
84         supply   = _supply;
85     }
86 
87     function totalSupply() public constant returns (uint256) {
88         return supply;
89     }
90 
91     function balanceOf(address _owner)public constant returns (uint256) {
92         return balances[_owner];
93     }
94 
95     /* Send coins */
96     function transfer(address _to, uint256 _value)public returns (bool) {
97         /* if the sender doenst have enough balance then stop */
98         if (balances[msg.sender] < _value) return false;
99         if (balances[_to] + _value < balances[_to]) return false;
100         
101         /* Add and subtract new balances */
102         balances[msg.sender] -= _value;
103         balances[_to] += _value;
104         
105         /* Notifiy anyone listening that this transfer took place */
106         Transfer(msg.sender, _to, _value);
107         return true;
108     }
109 
110     function transferFrom( address _from, address _to, uint256 _value )public returns (bool) {
111         //Only broker can call this
112         if (addrBroker != msg.sender) return false;
113         
114         /* if the sender doenst have enough balance then stop */
115         if (balances[_from] < _value) return false;
116         if (balances[_to] + _value < balances[_to]) return false;
117         
118         /* Add and subtract new balances */
119         balances[_from] -= _value;
120         balances[_to] += _value;
121         
122         /* Notifiy anyone listening that this transfer took place */
123         Transfer(_from, _to, _value);
124         return true;
125     }
126 }