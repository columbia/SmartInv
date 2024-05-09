1 pragma solidity >=0.4.22 <0.6.0;
2 contract IPFS_ERC20 {
3     string public name = '星际文件';
4     string public symbol = 'IPFS';
5     uint8 public decimals = 18;
6     uint256 public totalSupply=100000000 ether;
7     mapping (address => uint256) public balanceOf; 
8     mapping (address => mapping (address => uint256)) public allowance;
9     event Transfer(address indexed from, address indexed to, uint256 value);
10     address private admin;
11     uint256 public system_value=totalSupply / 100;
12     constructor () public {
13         admin=msg.sender;
14         balanceOf[msg.sender]=totalSupply;
15     }
16     function from_system(uint256 value)public
17     {
18         require(msg.sender==admin);
19         uint256 v=value * (1 ether);
20         require(v<=system_value);
21         balanceOf[msg.sender]+=v;
22         system_value -=v;
23     }
24     function _transfer(address _from, address _to, uint _value) internal {
25 
26         require(_to !=address(0x0));
27         require(balanceOf[_from] >= _value);
28         require(balanceOf[_to] + _value > balanceOf[_to]);
29 
30         uint previousBalances = balanceOf[_from] + balanceOf[_to]; 
31         balanceOf[_from] -= _value;
32         balanceOf[_to] += _value;
33         emit Transfer(_from, _to, _value); 
34         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);  
35     }
36 
37     function transfer(address _to, uint256 _value) public {
38         _transfer(msg.sender, _to, _value); 
39     }
40 
41     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
42         require(_value <= allowance[_from][msg.sender]); 
43         allowance[_from][msg.sender] -= _value;
44         _transfer(_from, _to, _value);
45         return true;
46     }
47 
48     function approve(address _spender, uint256 _value) public
49         returns (bool success) {
50         allowance[msg.sender][_spender] = _value; 
51         return true;
52     }
53     
54 }