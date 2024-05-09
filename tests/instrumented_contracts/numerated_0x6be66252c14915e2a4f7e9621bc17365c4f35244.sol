1 pragma solidity ^0.4.19;
2 
3 contract Token {
4 
5     function balanceOf(address _owner)  public constant returns (uint256 balance) {}
6     function transfer(address _to, uint256 _value) public  returns (bool success) {}
7     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success) {}
8     function approve(address _spender, uint256 _value)  public returns (bool success) {}
9     function allowance(address _owner, address _spender)  public constant returns (uint256 remaining) {}
10 
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13     event Changeethereallet(address indexed _etherwallet,address indexed _newwallet);
14 }
15 
16 contract Ownable {
17 
18     address public owner;
19     function Ownable() {
20         owner = msg.sender;
21     }
22 
23     modifier onlyOwner() {
24         require(msg.sender == owner);
25         _;
26     }
27   }
28 
29 contract StandardToken is Token {
30 
31     function transfer(address _to, uint256 _value) public returns (bool success) {
32       //  if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
33         if (balances[msg.sender] >= _value && _value > 0) {
34             balances[msg.sender] -= _value;
35             balances[_to] += _value;
36             Transfer(msg.sender, _to, _value);
37             return true;
38         } else { return false; }
39     }
40 
41 
42 
43     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
44         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
45         //?if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
46             if (balances[_from] >= _value  && _value > 0) {
47             balances[_to] += _value;
48             balances[_from] -= _value;
49             allowed[_from][msg.sender] -= _value;
50             Transfer(_from, _to, _value);
51             return true;
52         } else { return false; }
53     }
54 
55     function balanceOf(address _owner) constant public returns (uint256 balance) {
56         return balances[_owner];
57     }
58 
59     function approve(address _spender, uint256 _value) public returns (bool success) {
60         allowed[msg.sender][_spender] = _value;
61         Approval(msg.sender, _spender, _value);
62         return true;
63     }
64 
65     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
66       return allowed[_owner][_spender];
67     }
68 
69     mapping (address => uint256) balances;
70     mapping (address => mapping (address => uint256)) allowed;
71     uint256 public totalSupply;
72 }
73 
74 contract ZelaaCoin is StandardToken,Ownable {
75 
76  
77     string public name;           
78     uint256 public decimals;      
79     string public symbol;         
80 
81     address owner;
82     address tokenwallet;//= 0xbB502303929607bf3b5D8B968066bf8dd275720d;
83     address etherwallet;//= 0xdBfC66799F2f381264C4CaaE9178680E4cCE80B5;
84 
85     function changeEtherWallet(address _newwallet) onlyOwner() public returns (address) {
86     
87     etherwallet = _newwallet ;
88     Changeethereallet(etherwallet,_newwallet);
89     return ( _newwallet) ;
90 }
91 
92     function ZelaaCoin() public {
93         owner=msg.sender;
94         tokenwallet= 0xbB502303929607bf3b5D8B968066bf8dd275720d;
95         etherwallet= 0xdBfC66799F2f381264C4CaaE9178680E4cCE80B5;
96         name = "ZelaaCoin";
97         decimals = 18;            
98         symbol = "ZLC";          
99         totalSupply = 100000000 * (10**decimals);        
100         balances[tokenwallet] = totalSupply;               // Give the creator all initial tokens 
101     }
102 
103 
104     function getOwner() constant public returns(address){
105         return(owner);
106     }
107     
108     
109 }
110     
111 contract sendETHandtransferTokens is ZelaaCoin {
112     
113         mapping(address => uint256) balances;
114     
115         uint256 public totalETH;
116         event FundTransfer(address user, uint amount, bool isContribution);
117 
118 
119        function () payable public {
120         uint amount = msg.value;
121         totalETH += amount;
122         etherwallet.transfer(amount); 
123         FundTransfer(msg.sender, amount, true);
124     }
125     
126 }