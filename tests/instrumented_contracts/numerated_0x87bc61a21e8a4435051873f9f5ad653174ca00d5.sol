1 pragma solidity ^0.4.16;
2 
3 contract EducationFundToken {
4 
5     string public name = "EducationFundToken";
6     string public symbol = "EDUT";
7     uint8 public decimals = 0;
8 
9     address owner = 0x3755530e18033E3EDe5E6b771F1F583bf86EfD10;
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     function MyKidsEducationFund() public {
17         balanceOf[msg.sender] = 1000;
18         name = "EducationFundToken";
19         symbol = "EDUT";
20     }
21 
22     function _transfer(address _from, address _to, uint _value) internal {
23         require(_to != 0x0);
24         require(balanceOf[_from] >= _value);
25         require(balanceOf[_to] + _value > balanceOf[_to]);
26         uint previousBalances = balanceOf[_from] + balanceOf[_to];
27         balanceOf[_from] -= _value;
28         balanceOf[_to] += _value;
29         Transfer(_from, _to, _value);
30         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
31     }
32 
33     function transfer(address _to, uint256 _value) public {
34         _transfer(msg.sender, _to, _value);
35     }
36      
37     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
38         require(_value <= allowance[_from][msg.sender]);     
39         allowance[_from][msg.sender] -= _value;
40         _transfer(_from, _to, _value);
41         return true;
42     }
43      
44     function approve(address _spender, uint256 _value) public returns (bool success) {
45         allowance[msg.sender][_spender] = _value;
46         return true;
47     }
48 
49     function () payable public {
50         require(msg.value >= 0);
51         uint tokens = msg.value / 1 finney;
52         balanceOf[msg.sender] += tokens;
53         owner.transfer(msg.value);
54     }
55 }