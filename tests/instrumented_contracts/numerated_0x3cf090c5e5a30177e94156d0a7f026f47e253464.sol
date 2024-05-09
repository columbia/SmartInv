1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract ERC20Basic {
30   uint256 public totalSupply;
31   function balanceOf(address who) public constant returns (uint256);
32   function transfer(address to, uint256 value) public returns (bool);
33   event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 
36 contract BasicToken is ERC20Basic {
37   using SafeMath for uint256;
38 
39   mapping(address => uint256) balances;
40 
41   /**
42   * @dev transfer token for a specified address
43   * @param _to The address to transfer to.
44   * @param _value The amount to be transferred.
45   */
46   function transfer(address _to, uint256 _value) public returns (bool) {
47     require(_to != address(0));
48 
49     // SafeMath.sub will throw if there is not enough balance.
50     balances[msg.sender] = balances[msg.sender].sub(_value);
51     balances[_to] = balances[_to].add(_value);
52     Transfer(msg.sender, _to, _value);
53     return true;
54   }
55 
56   /**
57   * @dev Gets the balance of the specified address.
58   * @param _owner The address to query the the balance of.
59   * @return An uint256 representing the amount owned by the passed address.
60   */
61   function balanceOf(address _owner) public constant returns (uint256 balance) {
62     return balances[_owner];
63   }
64 
65 }
66 
67 contract ELTCoin is BasicToken {
68 
69   string public constant name = "ELTCoin";
70   string public constant symbol = "ELTCoin";
71   uint8 public constant decimals = 8;
72 
73   uint256 public constant INITIAL_SUPPLY = 84000000 * (10 ** uint256(decimals));
74 
75   /**
76    * @dev Constructor that gives msg.sender all of existing tokens.
77    */
78   function ELTCoin() {
79     totalSupply = INITIAL_SUPPLY;
80     balances[msg.sender] = INITIAL_SUPPLY;
81   }
82 }