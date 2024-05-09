1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9     uint256 public totalSupply;
10     function balanceOf(address who) constant returns (uint256);
11     function transfer(address to, uint256 value) returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20     
21     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
22         uint256 c = a * b;
23         assert(a == 0 || c / a == b);
24         return c;
25     }
26 
27     function div(uint256 a, uint256 b) internal constant returns (uint256) {
28         // assert(b > 0); // Solidity automatically throws when dividing by 0
29         uint256 c = a / b;
30         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31         return c;
32     }
33 
34     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     function add(uint256 a, uint256 b) internal constant returns (uint256) {
40         uint256 c = a + b;
41         assert(c >= a);
42         return c;
43     }
44 }
45 
46 /**
47  * @title Basic token
48  * @dev Basic version of StandardToken, with no allowances. 
49  */
50 contract BasicToken is ERC20Basic {
51     
52     using SafeMath for uint256;
53 
54     mapping(address => uint256) balances;
55 
56     /**
57     * @dev transfer token for a specified address
58     * @param _to The address to transfer to.
59     * @param _value The amount to be transferred.
60     */
61     function transfer(address _to, uint256 _value) returns (bool) {
62         balances[msg.sender] = balances[msg.sender].sub(_value);
63         balances[_to] = balances[_to].add(_value);
64         Transfer(msg.sender, _to, _value);
65         return true;
66     }
67 
68     /**
69     * @dev Gets the balance of the specified address.
70     * @param _owner The address to query the the balance of. 
71     * @return An uint256 representing the amount owned by the passed address.
72     */
73     function balanceOf(address _owner) constant returns (uint256 balance) {
74         return balances[_owner];
75     }
76 
77 }
78 
79 contract Wallet {
80 
81 	address owner;
82 
83 	function Wallet() {
84 		owner = msg.sender;
85 	}
86 
87 	function changeOwner(address _owner) returns (bool) {
88 		require(owner == msg.sender);
89 		owner = _owner;
90 		return true;
91 	}
92 
93 	function transfer(address _to, uint _value) returns (bool) {
94 		require(owner == msg.sender);
95 		require(_value <= this.balance);
96 		_to.transfer(_value);
97 		return true;
98 	}
99 
100 	function transferToken(address _token, address _to, uint _value) returns (bool) {
101 		require(owner == msg.sender);
102 		BasicToken token = BasicToken(_token);
103 		require(_value <= token.balanceOf(this));
104 		token.transfer(_to, _value);
105 		return true;
106 	}
107 
108 	function () payable {}
109 
110 	function tokenFallback(address _from, uint _value, bytes _data) {
111 		(_from); (_value); (_data);
112 	}
113 }