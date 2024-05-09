1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 
19 
20 
21 /**
22  * @title ERC20 interface
23  * @dev see https://github.com/ethereum/EIPs/issues/20
24  */
25 contract ERC20 is ERC20Basic {
26   function allowance(address owner, address spender) public view returns (uint256);
27   function transferFrom(address from, address to, uint256 value) public returns (bool);
28   function approve(address spender, uint256 value) public returns (bool);
29   event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 
33 library SafeMath {
34   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35     uint256 c = a * b;
36     assert(a == 0 || c / a == b);
37     return c;
38   }
39 
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return c;
45   }
46 
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     assert(c >= a);
55     return c;
56   }
57 }
58 
59 contract Hive is ERC20 {
60 
61     using SafeMath for uint;
62     string public constant name = "UHIVE";
63     string public constant symbol = "HVE";    
64     uint256 public constant decimals = 18;
65     uint256 _totalSupply = 80000000000 * (10**decimals);
66 
67     mapping (address => bool) public frozenAccount;
68     event FrozenFunds(address target, bool frozen);
69 
70     // Balances for each account
71     mapping(address => uint256) balances;
72 
73     // Owner of account approves the transfer of an amount to another account
74     mapping(address => mapping (address => uint256)) allowed;
75 
76     // Owner of this contract
77     address public owner;
78 
79     // Functions with this modifier can only be executed by the owner
80     modifier onlyOwner() {
81         require(msg.sender == owner);
82         _;
83     }
84 
85     function changeOwner(address _newOwner) onlyOwner public {
86         require(_newOwner != address(0));
87         owner = _newOwner;
88     }
89 
90     function freezeAccount(address target, bool freeze) onlyOwner public {
91         frozenAccount[target] = freeze;
92         FrozenFunds(target, freeze);
93     }
94 
95     function isFrozenAccount(address _addr) public constant returns (bool) {
96         return frozenAccount[_addr];
97     }
98 
99     function destroyCoins(address addressToDestroy, uint256 amount) onlyOwner public {
100         require(addressToDestroy != address(0));
101         require(amount > 0);
102         require(amount <= balances[addressToDestroy]);
103         balances[addressToDestroy] -= amount;    
104         _totalSupply -= amount;
105     }
106 
107     // Constructor
108     function Hive() public {
109         owner = msg.sender;
110         balances[owner] = _totalSupply;
111     }
112 
113     function totalSupply() public constant returns (uint256 supply) {
114         supply = _totalSupply;
115     }
116 
117     // What is the balance of a particular account?
118     function balanceOf(address _owner) public constant returns (uint256 balance) {
119         return balances[_owner];
120     }
121     
122     // Transfer the balance from owner's account to another account
123     function transfer(address _to, uint256 _value) public returns (bool success) {        
124         if (_to != address(0) && isFrozenAccount(msg.sender) == false && balances[msg.sender] >= _value && _value > 0 && balances[_to].add(_value) > balances[_to]) {
125             balances[msg.sender] = balances[msg.sender].sub(_value);
126             balances[_to] = balances[_to].add(_value);
127             Transfer(msg.sender, _to, _value);
128             return true;
129         } else {
130             return false;
131         }
132     }
133 
134     // Send _value amount of tokens from address _from to address _to
135     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
136     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
137     // fees in sub-currencies; the command should fail unless the _from account has
138     // deliberately authorized the sender of the message via some mechanism; we propose
139     // these standardized APIs for approval:
140     function transferFrom(address _from,address _to, uint256 _value) public returns (bool success) {
141         if (_to != address(0) && isFrozenAccount(_from) == false && balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0 && balances[_to].add(_value) > balances[_to]) {
142             balances[_from] = balances[_from].sub(_value);
143             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
144             balances[_to] = balances[_to].add(_value);
145             Transfer(_from, _to, _value);
146             return true;
147         } else {
148             return false;
149         }
150     }
151 
152     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
153     // If this function is called again it overwrites the current allowance with _value.
154     function approve(address _spender, uint256 _value) public returns (bool success) {
155         allowed[msg.sender][_spender] = _value;
156         Approval(msg.sender, _spender, _value);
157         return true;
158     }
159     
160     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
161         return allowed[_owner][_spender];
162     }
163     
164 }