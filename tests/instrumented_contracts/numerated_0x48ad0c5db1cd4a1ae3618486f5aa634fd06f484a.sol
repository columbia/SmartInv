1 pragma solidity ^0.4.4;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
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
33 contract ERC20Basic {
34   uint256 public totalSupply;
35   function balanceOf(address who) public constant returns (uint256);
36   function transfer(address to, uint256 value) public returns (bool);
37   event Transfer(address indexed from, address indexed to, uint256 value);
38 }
39 contract BasicToken is ERC20Basic {
40   using SafeMath for uint256;
41 
42   mapping(address => uint256) balances;
43 
44   /**
45   * @dev transfer token for a specified address
46   * @param _to The address to transfer to.
47   * @param _value The amount to be transferred.
48   */
49   function transfer(address _to, uint256 _value) public returns (bool) {
50     require(_to != address(0));
51 
52     // SafeMath.sub will throw if there is not enough balance.
53     balances[msg.sender] = balances[msg.sender].sub(_value);
54     balances[_to] = balances[_to].add(_value);
55     Transfer(msg.sender, _to, _value);
56     return true;
57   }
58 
59   /**
60   * @dev Gets the balance of the specified address.
61   * @param _owner The address to query the the balance of.
62   * @return An uint256 representing the amount owned by the passed address.
63   */
64   function balanceOf(address _owner) public constant returns (uint256 balance) {
65     return balances[_owner];
66   }
67 
68 }
69 contract BurnableToken is BasicToken {
70 
71     event Burn(address indexed burner, uint256 value);
72 
73     /**
74      * @dev Burns a specific amount of tokens.
75      * @param _value The amount of token to be burned.
76      */
77     function burn(uint256 _value) public {
78         require(_value > 0);
79 
80         address burner = msg.sender;
81         balances[burner] = balances[burner].sub(_value);
82         totalSupply = totalSupply.sub(_value);
83         Burn(burner, _value);
84     }
85 }
86 contract CGC is BurnableToken {
87 string public name = 'CGC';
88 string public symbol = 'CGC';
89 uint public decimals = 1;
90 uint public INITIAL_SUPPLY = 200000;
91 function CGC() public {
92   totalSupply = INITIAL_SUPPLY;
93   balances[msg.sender] = INITIAL_SUPPLY;
94 }
95 }