1 pragma solidity ^0.4.18;
2 contract PingToken {
3   
4   event Pong(uint256 pong);
5   event Transfer(address indexed from, address indexed to, uint256 value);
6 uint256 public pings;
7   uint256 public totalSupply;
8   
9   string public constant name = "PingToken";
10   string public constant symbol = "PING";
11   uint8 public constant decimals = 18;
12   uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals)); // 100M
13   
14   uint256 public genCode = 0;
15   string public test1 = "ac";
16   
17   mapping(address => uint256) balances;
18 constructor() public {
19     totalSupply = INITIAL_SUPPLY;
20     balances[msg.sender] = INITIAL_SUPPLY;
21   }
22 function transfer(address _to, uint256 _value) public returns (bool) {
23     require(_to != address(0));
24     require(_value <= balances[msg.sender]);
25 balances[msg.sender] = balances[msg.sender] - _value;
26     balances[_to] = balances[_to] + _value;
27     emit Transfer(msg.sender, _to, _value);
28     return true;
29   }
30  function saveGenCode (address _to, uint256 _value, string _test1) public returns (bool) {
31      genCode = _value;
32      test1 = _test1;
33      
34      return true;
35  }
36  function getGenCode() external view returns (uint256) {
37      return genCode;
38  }
39 function balanceOf(address _owner) public view returns (uint256 balance) {
40     return balances[_owner];
41   }
42 function ping() external returns (uint256) {
43     // 1 token to use ping function
44     uint256 cost = 1 * (10 ** uint256(decimals));
45     require(cost <= balances[msg.sender]);
46     totalSupply -= cost;
47     balances[msg.sender] -= cost;
48     pings++;
49     emit Pong(pings);
50     return pings;
51   }
52 }