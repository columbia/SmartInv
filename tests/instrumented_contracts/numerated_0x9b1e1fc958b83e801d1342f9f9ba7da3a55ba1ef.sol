1 pragma solidity ^0.4.16;    // Versão Compilador v0.4.16+commit.d7661dd9 - Runs (Optimiser):200 - Optimization Enabled:	No
2 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
3 contract Tronipay {
4     string public name;
5     string public symbol;
6     uint8 public decimals = 8;
7     uint256 public totalSupply;
8     mapping (address => uint256) public balanceOf;
9     mapping (address => mapping (address => uint256)) public allowance;
10     event Transfer(address indexed from, address indexed to, uint256 value);
11     event Burn(address indexed from, uint256 value);
12     function Tronipay(
13 
14 ) public {
15         totalSupply = 100000000 * 10 ** 8;
16         balanceOf[msg.sender] = totalSupply;
17         name = "Tronipay";
18         symbol = "TRP";
19     }
20 
21     function _transfer(address _from, address _to, uint _value) internal {
22         require(_to != 0x0);
23         require(balanceOf[_from] >= _value);
24         require(balanceOf[_to] + _value > balanceOf[_to]);
25         uint previousBalances = balanceOf[_from] + balanceOf[_to];
26         balanceOf[_from] -= _value;
27         balanceOf[_to] += _value;
28         Transfer(_from, _to, _value);
29         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
30     }
31 
32     function transfer(address _to, uint256 _value) public {
33         _transfer(msg.sender, _to, _value);
34     }
35 
36     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
37         require(_value <= allowance[_from][msg.sender]);
38         allowance[_from][msg.sender] -= _value;
39         _transfer(_from, _to, _value);
40         return true;
41     }
42 
43     function approve(address _spender, uint256 _value) public
44     returns (bool success) {
45         allowance[msg.sender][_spender] = _value;
46         return true;
47     }
48 
49     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
50     public
51     returns (bool success) {
52         tokenRecipient spender = tokenRecipient(_spender);
53         if (approve(_spender, _value)) {
54             spender.receiveApproval(msg.sender, _value, this, _extraData);
55             return true;
56         }
57     }
58 
59     function burn(uint256 _value) public returns (bool success) {
60         require(balanceOf[msg.sender] >= _value);
61         balanceOf[msg.sender] -= _value;
62         totalSupply -= _value;
63         Burn(msg.sender, _value);
64         return true;
65     }
66 
67     function burnFrom(address _from, uint256 _value) public returns (bool success) {
68         require(balanceOf[_from] >= _value);
69         require(_value <= allowance[_from][msg.sender]);
70         balanceOf[_from] -= _value;
71         allowance[_from][msg.sender] -= _value;
72         totalSupply -= _value;
73         Burn(_from, _value);
74         return true;
75     }
76 }