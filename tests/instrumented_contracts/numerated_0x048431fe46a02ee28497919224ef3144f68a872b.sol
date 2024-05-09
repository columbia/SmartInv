1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4   function sub(uint a, uint b) internal pure returns (uint) {
5     assert(b <= a);
6     return a - b;
7   }
8 
9   function add(uint a, uint b) internal pure returns (uint) {
10     uint c = a + b;
11     assert(c >= a);
12     return c;
13   }
14 }
15 
16 /**
17 * @title Contract that will work with ERC223 tokens.
18 */
19 contract ContractReceiver {
20   /**
21    * @dev Standard ERC223 function that will handle incoming token transfers.
22    *
23    * @param _from  Token sender address.
24    * @param _value Amount of tokens.
25    * @param _data  Transaction metadata.
26    */
27    
28   function tokenFallback(address _from, uint _value, bytes _data) public;
29 }
30 
31 /**
32  * @title ERC223 standard token implementation.
33  */
34 contract WBDToken {
35 	using SafeMath for uint256;
36 	
37 	uint256 public totalSupply;
38     string  public name;
39     string  public symbol;
40     uint8   public constant decimals = 8;
41 
42     address public owner;
43 	
44     mapping(address => uint256) balances; // List of user balances.
45 
46     function WBDToken(uint256 initialSupply, string tokenName, string tokenSymbol) public {
47         owner           =   msg.sender;
48 		totalSupply     =   initialSupply * 10 ** uint256(decimals);
49 		name            =   tokenName;
50 		symbol          =   tokenSymbol;
51         balances[owner] =   totalSupply;
52     }
53 
54 	event Transfer(address indexed from, address indexed to, uint256 value);  // ERC20
55     event Transfer(address indexed from, address indexed to, uint256 value, bytes data); // ERC233
56 	event Burn(address indexed from, uint256 amount, uint256 currentSupply, bytes data);
57 
58 
59 	/**
60      * @dev Transfer the specified amount of tokens to the specified address.
61      *      This function works the same with the previous one
62      *      but doesn't contain `_data` param.
63      *      Added due to backwards compatibility reasons.
64      *
65      * @param _to    Receiver address.
66      * @param _value Amount of tokens that will be transferred.
67      */
68     function transfer(address _to, uint _value) public returns (bool) {
69         bytes memory empty;
70 		transfer(_to, _value, empty);
71     }
72 
73 	/**
74      * @dev Transfer the specified amount of tokens to the specified address.
75      *      Invokes the `tokenFallback` function if the recipient is a contract.
76      *      The token transfer fails if the recipient is a contract
77      *      but does not implement the `tokenFallback` function
78      *      or the fallback function to receive funds.
79      *
80      * @param _to    Receiver address.
81      * @param _value Amount of tokens that will be transferred.
82      * @param _data  Transaction metadata.
83      */
84     function transfer(address _to, uint _value, bytes _data) public returns (bool) {
85         uint codeLength;
86 
87         assembly {
88             codeLength := extcodesize(_to)
89         }
90 
91         balances[msg.sender] = balances[msg.sender].sub(_value);
92         balances[_to] = balances[_to].add(_value);
93         if(codeLength>0) {
94             ContractReceiver receiver = ContractReceiver(_to);
95             receiver.tokenFallback(msg.sender, _value, _data);
96         }
97 		
98 		Transfer(msg.sender, _to, _value);
99         Transfer(msg.sender, _to, _value, _data);
100     }
101 	
102 	/**
103      * Destroy tokens
104      *
105      * Remove `_value` tokens from the system irreversibly
106      *
107      * @param _value the amount of money to burn
108 	 * @param _data  Transaction metadata.
109      */
110     function burn(uint256 _value, bytes _data) public returns (bool success) {
111 		balances[msg.sender] = balances[msg.sender].sub(_value);
112         totalSupply = totalSupply.sub(_value);
113         Burn(msg.sender, _value, totalSupply, _data);
114         return true;
115     }
116 	
117 	/**
118      * @dev Returns balance of the `_address`.
119      *
120      * @param _address   The address whose balance will be returned.
121      * @return balance Balance of the `_address`.
122      */
123     function balanceOf(address _address) public constant returns (uint256 balance) {
124         return balances[_address];
125     }
126 }