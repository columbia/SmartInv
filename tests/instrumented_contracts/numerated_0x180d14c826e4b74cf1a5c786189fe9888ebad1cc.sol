1 pragma solidity ^0.4.16;
2 ////
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 ////
5 contract AsinerumShareToken {
6   string public name = "Asinerum Share";
7   string public symbol = "ARS";
8   uint8 public decimals = 15;
9   uint64 public totalTokens = 172000000;
10   uint64 public priceTokenToCoin = 5000;
11   uint256 public totalSupply;
12   address public ownerWallet;
13   ////
14   mapping (address => uint256) public balanceOf;
15   mapping (address => mapping (address => uint256)) public allowance;
16   event Transfer(address indexed from, address indexed to, uint256 value);
17   ////
18   function AsinerumShareToken() public {
19     totalSupply = totalTokens * 10 ** uint256(decimals);
20     balanceOf[msg.sender] = totalSupply;
21     ownerWallet = msg.sender;
22   }
23   function _transfer(address _from, address _to, uint256 _value) internal {
24     require(_to != 0x0);
25     require(balanceOf[_from] >= _value);
26     require(balanceOf[_to] + _value > balanceOf[_to]);
27     balanceOf[_from] -= _value;
28     balanceOf[_to] += _value;
29     Transfer(_from, _to, _value);
30   }
31   function transfer(address _to, uint256 _value) public {
32     _transfer(msg.sender, _to, _value);
33   }
34   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
35     require(_value <= allowance[_from][msg.sender]);
36     allowance[_from][msg.sender] -= _value;
37     _transfer(_from, _to, _value);
38     return true;
39   }
40   function approve(address _spender, uint256 _value) public returns (bool success) {
41     allowance[msg.sender][_spender] = _value;
42     return true;
43   }
44   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
45     tokenRecipient spender = tokenRecipient(_spender);
46     if (approve(_spender, _value)) {
47       spender.receiveApproval(msg.sender, _value, this, _extraData);
48       return true;
49     }
50   }
51   function () payable public {
52     uint256 amount = msg.value * priceTokenToCoin;
53     amount = amount / 10 ** (18-uint256(decimals));
54     _transfer(ownerWallet, msg.sender, amount);
55   }
56 }