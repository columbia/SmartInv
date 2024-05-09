1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract TokenERC20 {
6     string public name;
7     string public symbol;
8     uint8 public decimals = 0;
9     uint256 public totalSupply;
10     address public owner;
11     mapping (address => uint256) public balanceOf;
12 
13     event Transfer(address indexed from, address indexed to, uint256 value);
14 
15     event Burn(address indexed from, uint256 value);
16 
17     modifier onlyOwner() {
18         require(msg.sender == owner);
19         _;                              
20     } 
21 
22     function TokenERC20(
23         uint256 initialSupply,
24         string tokenName,
25         string tokenSymbol
26     ) public {
27         owner = msg.sender;
28         totalSupply = initialSupply;  
29         balanceOf[msg.sender] = totalSupply;               
30         name = tokenName;                                   
31         symbol = tokenSymbol;   
32     }
33 
34     function _transfer(address _from, address _to, uint _value) internal {
35         require(_to != 0x0);
36         require(balanceOf[_from] >= _value);
37         require(balanceOf[_to] + _value > balanceOf[_to]);
38         uint previousBalances = balanceOf[_from] + balanceOf[_to];
39         balanceOf[_from] -= _value;
40         balanceOf[_to] += _value;
41         Transfer(_from, _to, _value);
42         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
43     }
44 
45     function transfer(address _to, uint256 _value) public {
46         _transfer(msg.sender, _to, _value);
47     }
48 
49     function burn(uint256 _value) onlyOwner public returns (bool success) {
50         require(balanceOf[msg.sender] >= _value);   
51         balanceOf[msg.sender] -= _value;            
52         totalSupply -= _value;                     
53         Burn(msg.sender, _value);
54         return true;
55     }
56 
57     function transferOwnership(address newOwner) public onlyOwner {
58             owner = newOwner;
59     }
60 
61     function createTokens(address _target, uint amount)public onlyOwner {
62         balanceOf[_target] += amount;
63         totalSupply += amount;
64         Transfer(0, owner, amount);
65         Transfer(owner, _target, amount);
66     }
67 }