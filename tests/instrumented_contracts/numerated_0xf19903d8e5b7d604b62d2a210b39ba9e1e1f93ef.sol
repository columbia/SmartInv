1 pragma solidity ^0.4.18;
2  library SafeMath {
3       function add(uint a, uint b) internal pure returns (uint c) {
4           c = a + b;
5           require(c >= a);
6       }
7       function sub(uint a, uint b) internal pure returns (uint c) {
8           require(b <= a);
9           c = a - b;
10       }
11       function mul(uint a, uint b) internal pure returns (uint c) {
12           c = a * b;
13           require(a == 0 || c / a == b);
14       }
15       function div(uint a, uint b) internal pure returns (uint c) {
16           require(b > 0);
17           c = a / b;
18       }
19   }
20  contract STASHInterface {
21       function totalSupply() public constant returns (uint);
22       function balanceOf(address tokenOwner) public constant returns (uint balance);
23       function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
24       function transfer(address to, uint tokens) public returns (bool success);
25       function approve(address spender, uint tokens) public returns (bool success);
26       function transferFrom(address from, address to, uint tokens) public returns (bool success);
27   
28       event Transfer(address indexed from, address indexed to, uint tokens);
29       event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
30   }
31  contract ApproveAndCallFallBack {
32       function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
33   }
34  contract Owned {
35       address public owner;
36       address public newOwner;
37   
38       event OwnershipTransferred(address indexed _from, address indexed _to);
39   
40       function Owned() public {
41           owner = msg.sender;
42       }
43   
44       modifier onlyOwner {
45           require(msg.sender == owner);
46           _;
47       }
48   
49       function transferOwnership(address _newOwner) public onlyOwner {
50           newOwner = _newOwner;
51       }
52       function acceptOwnership() public {
53           require(msg.sender == newOwner);
54           OwnershipTransferred(owner, newOwner);
55           owner = newOwner;
56           newOwner = address(0);
57       }
58   }
59  contract STASHToken is STASHInterface, Owned {
60      using SafeMath for uint;
61  
62      string public symbol;
63      string public  name;
64      uint8 public decimals;
65      uint public _totalSupply;
66      uint256 public unitsOneEthCanBuy;     
67      uint256 public totalEthInWei;           
68      address public fundsWallet;          
69  
70      mapping(address => uint) balances;
71      mapping(address => mapping(address => uint)) allowed;
72  
73  
74      function STASHToken() public {
75          symbol = "STASH";
76          name = "BitStash";
77          decimals = 18;
78          _totalSupply = 36000000000 * 10**uint(decimals);
79          balances[owner] = _totalSupply;
80          Transfer(address(0), owner, _totalSupply);
81          unitsOneEthCanBuy = 600000;                                     
82          fundsWallet = msg.sender;                                   
83      }
84  
85      function totalSupply() public constant returns (uint) {
86          return _totalSupply  - balances[address(0)];
87      }
88  
89      function balanceOf(address tokenOwner) public constant returns (uint balance) {
90          return balances[tokenOwner];
91      }
92  
93      function transfer(address to, uint tokens) public returns (bool success) {
94          balances[msg.sender] = balances[msg.sender].sub(tokens);
95          balances[to] = balances[to].add(tokens);
96          Transfer(msg.sender, to, tokens);
97          return true;
98      }
99  
100      function approve(address spender, uint tokens) public returns (bool success) {
101          allowed[msg.sender][spender] = tokens;
102          Approval(msg.sender, spender, tokens);
103          return true;
104      }
105  
106      function transferFrom(address from, address to, uint tokens) public returns (bool success) {
107          balances[from] = balances[from].sub(tokens);
108          allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
109          balances[to] = balances[to].add(tokens);
110          Transfer(from, to, tokens);
111          return true;
112      }
113  
114      function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
115          return allowed[tokenOwner][spender];
116      }
117  
118      function() payable public{
119         totalEthInWei = totalEthInWei + msg.value;
120         uint256 amount = msg.value * unitsOneEthCanBuy;
121         if (balances[fundsWallet] < amount) {
122             return;
123         }
124 
125         balances[fundsWallet] = balances[fundsWallet] - amount;
126         balances[msg.sender] = balances[msg.sender] + amount;
127 
128         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
129 
130         //Transfer ether to fundsWallet
131         fundsWallet.transfer(msg.value);                               
132     }
133 
134     /* Approves and then calls the receiving contract */
135     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
136         allowed[msg.sender][_spender] = _value;
137         Approval(msg.sender, _spender, _value);
138 
139         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
140         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
141         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
142         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
143         return true;
144     }
145  
146      function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
147          return STASHInterface(tokenAddress).transfer(owner, tokens);
148      }
149  }