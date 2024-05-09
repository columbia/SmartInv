1 pragma solidity ^0.4.13;
2 contract Tbyc {
3     address public owner;
4     string  public name;
5     string  public symbol;
6     uint8   public decimals;
7     uint256 public totalSupply;
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     /* This generates a public event on the blockchain that will notify clients */
13     event Transfer(address indexed from, address indexed to, uint256 value);
14 
15     /* This notifies clients about the amount burnt */
16     event Burn(address indexed from, uint256 value);
17 
18     /* Initializes contract with initial supply tokens to the creator of the contract */
19     function Tbyc() {
20       owner = 0x0a09B58084554786215Dabe7Ab645cB17b1e490E;
21       name = 'BaoYing Chain';
22       symbol = 'TBYC';
23       decimals = 18;
24       totalSupply = 1314000000000000000000000000; // 2e28
25       balanceOf[owner] = 1314000000000000000000000000;
26     }
27 
28     /* Send coins */
29     function transfer(address _to, uint256 _value) returns (bool success) {
30       require(balanceOf[msg.sender] >= _value);
31 
32       balanceOf[msg.sender] -= _value;
33       balanceOf[_to] += _value;
34       Transfer(msg.sender, _to, _value);
35       return true;
36     }
37 
38     /* Allow another contract to spend some tokens in your behalf */
39     function approve(address _spender, uint256 _value) returns (bool success) {
40       allowance[msg.sender][_spender] = _value;
41       return true;
42     }
43 
44     /* A contract attempts to get the coins */
45     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
46       require(balanceOf[_from] >= _value);
47       require(allowance[_from][msg.sender] >= _value);
48 
49       balanceOf[_from] -= _value;
50       balanceOf[_to] += _value;
51       allowance[_from][msg.sender] -= _value;
52       Transfer(_from, _to, _value);
53       return true;
54     }
55 
56     function burn(uint256 _value) returns (bool success) {
57       require(balanceOf[msg.sender] >= _value);
58 
59       balanceOf[msg.sender] -= _value;
60       totalSupply -= _value;
61       Burn(msg.sender, _value);
62       return true;
63     }
64 }