1 pragma solidity ^0.4.16;
2 
3 contract KYRToken {
4 
5     string public name;
6     string public symbol;
7     uint8 public decimals = 18;
8 
9     uint256 public totalSupply;
10 
11 
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14 
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     event Burn(address indexed from, uint256 value);
19 
20     function KYRToken() public {
21         totalSupply = 1000000000 * 10 ** uint256(decimals);
22         balanceOf[msg.sender] = totalSupply;
23         name = "KYROS";
24         symbol = "KYR";
25     }
26 
27     function _transfer(address _from, address _to, uint _value) internal {
28         require(_to != 0x0);
29         require(balanceOf[_from] >= _value);
30         require(balanceOf[_to] + _value > balanceOf[_to]);
31         uint previousBalances = balanceOf[_from] + balanceOf[_to];
32         balanceOf[_from] -= _value;
33         balanceOf[_to] += _value;
34         Transfer(_from, _to, _value);
35         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
36     }
37 
38     function transfer(address _to, uint256 _value) public {
39         _transfer(msg.sender, _to, _value);
40     }
41      
42     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
43         require(_value <= allowance[_from][msg.sender]);     
44         allowance[_from][msg.sender] -= _value;
45         _transfer(_from, _to, _value);
46         return true;
47     }
48      
49     function approve(address _spender, uint256 _value) public returns (bool success) {
50         allowance[msg.sender][_spender] = _value;
51         return true;
52     }
53 }