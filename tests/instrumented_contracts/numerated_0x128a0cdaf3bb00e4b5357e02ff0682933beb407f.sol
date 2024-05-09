1 pragma solidity ^0.4.18;
2 
3  library SafeMath {
4       function add(uint a, uint b) internal pure returns (uint c) {
5           c = a + b;
6           require(c >= a);
7       }
8       function sub(uint a, uint b) internal pure returns (uint c) {
9           require(b <= a);
10           c = a - b;
11       }
12       function mul(uint a, uint b) internal pure returns (uint c) {
13           c = a * b;
14           require(a == 0 || c / a == b);
15       }
16       function div(uint a, uint b) internal pure returns (uint c) {
17           require(b > 0);
18           c = a / b;
19       }
20   }
21   
22  contract ERXInterface {
23       function totalSupply() public constant returns (uint);
24       function balanceOf(address tokenOwner) public constant returns (uint balance);
25       function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
26       function transfer(address to, uint tokens) public returns (bool success);
27       function approve(address spender, uint tokens) public returns (bool success);
28       function transferFrom(address from, address to, uint tokens) public returns (bool success);
29       event Transfer(address indexed from, address indexed to, uint tokens);
30       event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
31   }
32   
33  contract ApproveAndCallFallBack {
34       function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
35   }
36   
37  contract Owned {
38       address public owner;
39       address public newOwner;
40   
41       event OwnershipTransferred(address indexed _from, address indexed _to);
42   
43       function Owned() public {
44           owner = msg.sender;
45       }
46   
47       modifier onlyOwner {
48           require(msg.sender == owner);
49           _;
50       }
51   
52       function transferOwnership(address _newOwner) public onlyOwner {
53           newOwner = _newOwner;
54       }
55       function acceptOwnership() public {
56           require(msg.sender == newOwner);
57           OwnershipTransferred(owner, newOwner);
58           owner = newOwner;
59           newOwner = address(0);
60       }
61   }
62   
63  contract ERC20Connect is ERXInterface, Owned {
64      using SafeMath for uint;
65  
66      string public symbol;
67      string public  name;
68      uint8 public decimals;
69      uint public _totalSupply;
70      uint256 public unitsOneEthCanBuy;     
71      uint256 public totalEthInWei;           
72      address public fundsWallet;          
73      mapping(address => uint) balances;
74      mapping(address => mapping(address => uint)) allowed;
75  
76      function ERC20Connect() public {
77          symbol = "ERX";
78          name = "ERC20Connect";
79          decimals = 18;
80          _totalSupply = 21000000 * 10**uint(decimals);
81          balances[owner] = _totalSupply;
82          Transfer(address(0), owner, _totalSupply);
83          unitsOneEthCanBuy = 5000;                                     
84          fundsWallet = msg.sender;                                   
85      }
86  
87      function totalSupply() public constant returns (uint) {
88          return _totalSupply  - balances[address(0)];
89      }
90  
91      function balanceOf(address tokenOwner) public constant returns (uint balance) {
92          return balances[tokenOwner];
93      }
94  
95      function transfer(address to, uint tokens) public returns (bool success) {
96          balances[msg.sender] = balances[msg.sender].sub(tokens);
97          balances[to] = balances[to].add(tokens);
98          Transfer(msg.sender, to, tokens);
99          return true;
100      }
101  
102      function approve(address spender, uint tokens) public returns (bool success) {
103          allowed[msg.sender][spender] = tokens;
104          Approval(msg.sender, spender, tokens);
105          return true;
106      }
107  
108      function transferFrom(address from, address to, uint tokens) public returns (bool success) {
109          balances[from] = balances[from].sub(tokens);
110          allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
111          balances[to] = balances[to].add(tokens);
112          Transfer(from, to, tokens);
113          return true;
114      }
115  
116      function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
117          return allowed[tokenOwner][spender];
118      }
119  
120      function() payable public{
121         totalEthInWei = totalEthInWei + msg.value;
122         uint256 amount = msg.value * unitsOneEthCanBuy;
123         if (balances[fundsWallet] < amount) {
124             return;
125         }
126 
127         balances[fundsWallet] = balances[fundsWallet] - amount;
128         balances[msg.sender] = balances[msg.sender] + amount;
129 
130         Transfer(fundsWallet, msg.sender, amount);
131 
132         fundsWallet.transfer(msg.value);                               
133     }
134 
135     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
136         allowed[msg.sender][_spender] = _value;
137         Approval(msg.sender, _spender, _value);
138         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
139         return true;
140     }
141  
142      function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
143          return ERXInterface(tokenAddress).transfer(owner, tokens);
144      }
145  }