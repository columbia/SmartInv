1 pragma solidity ^0.4.13;
2 
3 contract AbxyjoyCoin {
4     address public owner;
5     string  public name;
6     string  public symbol;
7     uint8   public decimals;
8     uint256 public totalSupply;
9 
10     mapping (address => uint256) public balanceOf;
11     mapping (address => mapping (address => uint256)) public allowance;
12 
13     /* This generates a public event on the blockchain that will notify clients */
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     /* Initializes contract with initial supply tokens to the creator of the contract */
17     function AbxyjoyCoin() {
18       owner = msg.sender;
19       name = 'Abxyjoy Coin';
20       symbol = 'AOY';
21       decimals = 18;
22       totalSupply = 210000000000000000000000000;  // 2.1e26
23       balanceOf[owner] = 210000000000000000000000000;
24     }
25 
26     /* Send coins */
27     function transfer(address _to, uint256 _value) returns (bool success) {
28       require(balanceOf[msg.sender] >= _value);
29 
30       balanceOf[msg.sender] -= _value;
31       balanceOf[_to] += _value;
32       Transfer(msg.sender, _to, _value);
33       return true;
34     }
35 
36     /* Allow another contract to spend some tokens in your behalf */
37     function approve(address _spender, uint256 _value) returns (bool success) {
38       allowance[msg.sender][_spender] = _value;
39       return true;
40     }
41 
42     /* A contract attempts to get the coins */
43     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
44       require(balanceOf[_from] >= _value);
45       require(allowance[_from][msg.sender] >= _value);
46 
47       balanceOf[_from] -= _value;
48       balanceOf[_to] += _value;
49       allowance[_from][msg.sender] -= _value;
50       Transfer(_from, _to, _value);
51       return true;
52     }
53 }