1 pragma solidity ^0.4.15;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract Token {
34 
35 
36     /// @return total amount of tokens
37     function totalSupply() constant returns (uint256 supply) {}
38     function balanceOf(address _owner) constant returns (uint256 balance) {}
39     function transfer(address _to, uint256 _value) returns (bool success) {}
40     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
41     function approve(address _spender, uint256 _value) returns (bool success) {}
42     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
43     function burnToken(uint256 _value) {}
44 
45     event Transfer(address indexed _from, address indexed _to, uint256 _value);
46     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
47     event Burn(address indexed burner, uint256 value);
48 
49 }
50 
51 contract Ownable {
52   address public owner;
53 
54   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56   /**
57    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58    * account.
59    */
60   function Ownable() {
61     owner = msg.sender;
62   }
63 
64   /**
65    * @dev Throws if called by any account other than the owner.
66    */
67   modifier onlyOwner() {
68     require(msg.sender == owner);
69     _;
70   }
71 
72   /**
73    * @dev Allows the current owner to transfer control of the contract to a newOwner.
74    * @param newOwner The address to transfer ownership to.
75    */
76   function transferOwnership(address newOwner) onlyOwner public {
77     require(newOwner != address(0));
78     OwnershipTransferred(owner, newOwner);
79     owner = newOwner;
80   }
81 }
82 
83 contract StandardToken is Token, Ownable {
84 
85     using SafeMath for uint256;
86 
87     function transfer(address _to, uint256 _value) returns (bool success) {
88         //Default assumes totalSupply can't be over max (2^256 - 1).
89         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
90         //Replace the if with this one instead.
91         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
92         if (balances[msg.sender] >= _value && _value > 0) {
93             balances[msg.sender] -= _value;
94             balances[_to] += _value;
95             Transfer(msg.sender, _to, _value);
96             return true;
97         } else { return false; }
98     }
99 
100     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
101         //same as above. Replace this line with the following if you want to protect against wrapping uints.
102         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
103         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
104             balances[_to] += _value;
105             balances[_from] -= _value;
106             allowed[_from][msg.sender] -= _value;
107             Transfer(_from, _to, _value);
108             return true;
109         } else { return false; }
110     }
111 
112     function balanceOf(address _owner) constant returns (uint256 balance) {
113         return balances[_owner];
114     }
115 
116     function approve(address _spender, uint256 _value) returns (bool success) {
117         allowed[msg.sender][_spender] = _value;
118         Approval(msg.sender, _spender, _value);
119         return true;
120     }
121 
122     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
123       return allowed[_owner][_spender];
124     }
125 
126     function burnToken(uint256 _value) onlyOwner{
127     require(_value > 0);
128     require(_value <= balances[msg.sender]);
129 
130     address burner = msg.sender;
131     balances[burner] = balances[burner].sub(_value);
132     totalSupply = totalSupply.sub(_value);
133     Burn(burner, _value);
134     }
135 
136     mapping (address => uint256) balances;
137     mapping (address => mapping (address => uint256)) allowed;
138     uint256 public totalSupply;
139 
140 
141 }
142 
143 
144 //name this contract whatever you'd like
145 contract DatoxToken is StandardToken {
146 
147     function () {
148         //if ether is sent to this address, send it back.
149         throw;
150     }
151 
152     string public constant name = "DATOX";
153     string public constant symbol = "DTX";
154     uint8 public constant decimals = 8;
155 
156     uint256 public constant INITIAL_SUPPLY = 200000000 * (10 ** uint256(decimals));
157 
158     function DatoxToken() {
159         balances[msg.sender] = INITIAL_SUPPLY;               // Give the creator all initial tokens (100000 for example)
160         totalSupply = INITIAL_SUPPLY;                        // Update total supply (100000 for example)
161     }
162 
163     /* Approves and then calls the receiving contract */
164     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
165         allowed[msg.sender][_spender] = _value;
166         Approval(msg.sender, _spender, _value);
167 
168         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
169         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
170         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
171         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
172         return true;
173     }
174 }