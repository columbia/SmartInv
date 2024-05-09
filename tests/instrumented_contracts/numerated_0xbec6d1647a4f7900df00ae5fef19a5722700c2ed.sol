1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata_extraData) external;
5 }
6 
7 contract TokenERC20 {
8     string public name;
9     string public symbol;
10     uint8 public decimals = 3;
11     uint256 public totalSupply;
12 
13     mapping (address => uint256) public balanceOf;
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 
20     event Burn(address indexed from, uint256 value);
21 
22     constructor() public {
23         totalSupply = 3 * 1000 * 1000 * 1000 * 1000;
24         balanceOf[msg.sender] = totalSupply;
25         name = "맨체스터 유나이티드 코인";
26         symbol = "MU";
27     }
28 
29     function _transfer(address _from, address _to, uint _value) internal {
30         require(_to != address(0x0));
31         require(balanceOf[_from] >= _value);
32         require(balanceOf[_to] + _value >= balanceOf[_to]);
33         uint previousBalances = balanceOf[_from] + balanceOf[_to];
34         balanceOf[_from] -= _value;
35         balanceOf[_to] += _value;
36         emit Transfer(_from, _to, _value);
37         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
38     }
39 
40     function transfer(address _to, uint256 _value) public returns (bool success) {
41         _transfer(msg.sender, _to, _value);
42         return true;
43     }
44 
45     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
46         require(_value <= allowance[_from][msg.sender]);
47         allowance[_from][msg.sender] -= _value;
48         _transfer(_from, _to, _value);
49         return true;
50     }
51 
52     function approve(address _spender, uint256 _value) public
53         returns (bool success) {
54         allowance[msg.sender][_spender] = _value;
55         emit Approval(msg.sender, _spender, _value);
56         return true;
57     }
58 
59     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
60         public
61         returns (bool success) {
62         tokenRecipient spender = tokenRecipient(_spender);
63         if (approve(_spender, _value)) {
64             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
65             return true;
66         }
67     }
68 
69     function burn(uint256 _value) public returns (bool success) {
70         require(balanceOf[msg.sender] >= _value);
71         balanceOf[msg.sender] -= _value;
72         totalSupply -= _value;
73         emit Burn(msg.sender, _value);
74         return true;
75     }
76 
77     function burnFrom(address _from, uint256 _value) public returns (bool success) {
78         require(balanceOf[_from] >= _value);
79         require(_value <= allowance[_from][msg.sender]);
80         balanceOf[_from] -= _value;
81         allowance[_from][msg.sender] -= _value;
82         totalSupply -= _value;
83         emit Burn(_from, _value);
84         return true;
85     }
86 }