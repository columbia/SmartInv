1 pragma solidity ^0.4.16;
2 
3 contract MyKidsEducationFund {
4   string public constant symbol = "MKEF";
5   string public constant name = "MyKidsEducationFund";
6   uint8 public constant decimals = 18;
7 
8   address owner = 0x3755530e18033E3EDe5E6b771F1F583bf86EfD10;
9 
10   mapping (address => uint256) public balances;
11 
12   event Transfer(address indexed _from, address indexed _to, uint256 _value);
13 
14   function MyKidsEducationFund() public {
15     balances[msg.sender] = 1000;
16   }
17 
18   function transfer(address _to, uint256 _value) public returns (bool success) {
19     require(balances[msg.sender] >= _value);
20     require(_value > 0);
21     require(balances[_to] + _value >= balances[_to]);
22     balances[msg.sender] -= _value;
23     balances[_to] += _value;
24     Transfer(msg.sender, _to, _value);
25     return true;
26   }
27 
28   function () payable public {
29     require(msg.value >= 0);
30     uint tokens = msg.value / 10 finney;
31     balances[msg.sender] += tokens;
32     owner.transfer(msg.value);
33   }
34 }