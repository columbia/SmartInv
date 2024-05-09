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
14   mapping(address => uint256) balances;
15 function PingToken() public {
16     totalSupply = INITIAL_SUPPLY;
17     balances[msg.sender] = INITIAL_SUPPLY;
18   }
19 function transfer(address _to, uint256 _value) public returns (bool) {
20     require(_to != address(0));
21     require(_value <= balances[msg.sender]);
22 balances[msg.sender] = balances[msg.sender] - _value;
23     balances[_to] = balances[_to] + _value;
24     emit Transfer(msg.sender, _to, _value);
25     return true;
26   }
27 function balanceOf(address _owner) public view returns (uint256 balance) {
28     return balances[_owner];
29   }
30 function ping() external returns (uint256) {
31     // 1 token to use ping function
32     uint256 cost = 1 * (10 ** uint256(decimals));
33     require(cost <= balances[msg.sender]);
34     totalSupply -= cost;
35     balances[msg.sender] -= cost;
36     pings++;
37     emit Pong(pings);
38     return pings;
39   }
40 }