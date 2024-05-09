1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; 
5 }
6 
7 contract TokenERC20 {
8     string public name;
9     string public symbol;
10     uint8 public decimals = 8;
11     uint256 public totalSupply;
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Burn(address indexed from, uint256 value);
16     
17     function TokenERC20(
18         uint256 initialSupply,
19         string tokenName,
20         string tokenSymbol
21     ) public {
22         totalSupply = initialSupply * 10 ** uint256(decimals);
23         balanceOf[msg.sender] = totalSupply;
24         name = tokenName;
25         symbol = tokenSymbol;
26     }
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
49     function approve(address _spender, uint256 _value) public
50         returns (bool success) {
51         allowance[msg.sender][_spender] = _value;        
52         return true;
53     }
54 }