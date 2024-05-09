1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b)  internal pure returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b)  internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b)  internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b)  internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 
34 contract ERC20Basic {
35     uint256 public totalSupply;
36     function balanceOf(address who) public constant returns (uint256);
37     function transfer(address to, uint256 value) public returns (bool);
38     event Transfer(address indexed from, address indexed to, uint256 value);
39 }
40 
41 /**
42  * @title Basic token
43  * @dev Basic version of StandardToken, with no allowances.
44  */
45 contract BasicToken is ERC20Basic {
46     using SafeMath for uint256;
47 
48     mapping(address => uint256) balances;
49 
50     
51     function transfer(address _to, uint256 _value) public returns (bool) {
52         require(_to != address(0));
53 
54         // SafeMath.sub will throw if there is not enough balance.
55         balances[msg.sender] = balances[msg.sender].sub(_value);
56         balances[_to] = balances[_to].add(_value);
57         emit Transfer(msg.sender, _to, _value);
58         return true;
59     }
60 
61     
62     function balanceOf(address _owner) public constant returns (uint256 balance) {
63         return balances[_owner];
64     }
65 
66 }
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 contract ERC20 is ERC20Basic {
72     function allowance(address owner, address spender) public constant returns (uint256);
73     function transferFrom(address from, address to, uint256 value) public returns (bool);
74     function approve(address spender, uint256 value) public returns (bool);
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 
79 
80 contract StandardToken is ERC20, BasicToken {
81 
82     mapping (address => mapping (address => uint256)) allowed;
83 
84 
85    
86     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
87         require(_to != address(0));
88 
89         uint256 _allowance = allowed[_from][msg.sender];
90 
91         balances[_from] = balances[_from].sub(_value);
92         balances[_to] = balances[_to].add(_value);
93         allowed[_from][msg.sender] = _allowance.sub(_value);
94         emit Transfer(_from, _to, _value);
95         return true;
96     }
97 
98     
99     function approve(address _spender, uint256 _value) public returns (bool) {
100         allowed[msg.sender][_spender] = _value;
101         emit Approval(msg.sender, _spender, _value);
102         return true;
103     }
104 
105     
106     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
107         return allowed[_owner][_spender];
108     }
109 
110     
111     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
112         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
113         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
114         return true;
115     }
116 
117     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
118         uint oldValue = allowed[msg.sender][_spender];
119         if (_subtractedValue > oldValue) {
120             allowed[msg.sender][_spender] = 0;
121         } else {
122             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
123         }
124         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
125         return true;
126     }
127 
128 }
129 
130 contract SkyvToken is StandardToken {
131     string public name = "Skyv Token";
132     string public symbol = "SKV";
133     uint public decimals = 18;
134     uint public INIT_SUPPLY = 2100000000 * (10 ** decimals);
135 
136     constructor() public {
137         totalSupply = INIT_SUPPLY;
138         balances[msg.sender] = INIT_SUPPLY;
139         emit Transfer(0x0, msg.sender, INIT_SUPPLY);
140     }
141     
142     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
143         allowed[msg.sender][_spender] = _value;
144         emit Approval(msg.sender, _spender, _value);
145 
146         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
147         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
148         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
149         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
150         return true;
151     }
152 }