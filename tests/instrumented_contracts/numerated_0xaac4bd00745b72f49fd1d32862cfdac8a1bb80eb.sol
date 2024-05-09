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
15   
16   mapping(address => uint256) balances;
17 constructor() public {
18     totalSupply = INITIAL_SUPPLY;
19     balances[msg.sender] = INITIAL_SUPPLY;
20   }
21 function transfer(address _to, uint256 _value) public returns (bool) {
22     require(_to != address(0));
23     require(_value <= balances[msg.sender]);
24 balances[msg.sender] = balances[msg.sender] - _value;
25     balances[_to] = balances[_to] + _value;
26     emit Transfer(msg.sender, _to, _value);
27     return true;
28   }
29  function saveGenCode (address _to, uint256 _value) public returns (bool) {
30      genCode = _value;
31      return true;
32  }
33  function getGenCode() external view returns (uint256) {
34      return genCode;
35  }
36 function balanceOf(address _owner) public view returns (uint256 balance) {
37     return balances[_owner];
38   }
39 function ping() external returns (uint256) {
40     // 1 token to use ping function
41     uint256 cost = 1 * (10 ** uint256(decimals));
42     require(cost <= balances[msg.sender]);
43     totalSupply -= cost;
44     balances[msg.sender] -= cost;
45     pings++;
46     emit Pong(pings);
47     return pings;
48   }
49 }