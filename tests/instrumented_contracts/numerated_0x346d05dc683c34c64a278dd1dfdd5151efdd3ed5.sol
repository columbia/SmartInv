1 /**
2  * Verified by 3esmit
3 */
4 
5 pragma solidity ^0.4.13;
6 
7 /**
8  * @title ERC20Basic
9  * @dev Simpler version of ERC20 interface
10  * @dev see https://github.com/ethereum/EIPs/issues/179
11  */
12 contract ERC20Basic {
13     uint256 public totalSupply;
14     function balanceOf(address who) constant returns (uint256);
15     function transfer(address to, uint256 value) returns (bool);
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24     
25     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
26         uint256 c = a * b;
27         assert(a == 0 || c / a == b);
28         return c;
29     }
30 
31     function div(uint256 a, uint256 b) internal constant returns (uint256) {
32         // assert(b > 0); // Solidity automatically throws when dividing by 0
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35         return c;
36     }
37 
38     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     function add(uint256 a, uint256 b) internal constant returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 /**
51  * @title Basic token
52  * @dev Basic version of StandardToken, with no allowances. 
53  */
54 contract BasicToken is ERC20Basic {
55     
56     using SafeMath for uint256;
57 
58     mapping(address => uint256) balances;
59 
60     /**
61     * @dev transfer token for a specified address
62     * @param _to The address to transfer to.
63     * @param _value The amount to be transferred.
64     */
65     function transfer(address _to, uint256 _value) returns (bool) {
66         balances[msg.sender] = balances[msg.sender].sub(_value);
67         balances[_to] = balances[_to].add(_value);
68         Transfer(msg.sender, _to, _value);
69         return true;
70     }
71 
72     /**
73     * @dev Gets the balance of the specified address.
74     * @param _owner The address to query the the balance of. 
75     * @return An uint256 representing the amount owned by the passed address.
76     */
77     function balanceOf(address _owner) constant returns (uint256 balance) {
78         return balances[_owner];
79     }
80 
81 }
82 
83 contract Wallet {
84 
85 	address owner;
86 
87 	function Wallet() {
88 		owner = msg.sender;
89 	}
90 
91 	function changeOwner(address _owner) returns (bool) {
92 		require(owner == msg.sender);
93 		owner = _owner;
94 		return true;
95 	}
96 
97 	function transfer(address _to, uint _value) returns (bool) {
98 		require(owner == msg.sender);
99 		require(_value <= this.balance);
100 		_to.transfer(_value);
101 		return true;
102 	}
103 
104 	function transferToken(address _token, address _to, uint _value) returns (bool) {
105 		require(owner == msg.sender);
106 		BasicToken token = BasicToken(_token);
107 		require(_value <= token.balanceOf(this));
108 		token.transfer(_to, _value);
109 		return true;
110 	}
111 
112 	function () payable {}
113 
114 	function tokenFallback(address _from, uint _value, bytes _data) {
115 		(_from); (_value); (_data);
116 	}
117 }