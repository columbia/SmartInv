1 pragma solidity ^0.4.18;
2 
3 contract TokenInterface{
4     uint256 public totalSupply;
5     uint256 public price;
6     uint256 public decimals;
7     function () public payable;
8     function balanceOf(address _owner) view public returns(uint256);
9     function transfer(address _to, uint256 _value) public returns(bool);
10 }
11 
12 contract SWAP{
13     
14     string public name="SWAP";
15     string public symbol="SWAP";
16     
17     uint256 public totalSupply; 
18     uint256 public price = 50;
19     uint256 public decimals = 18; 
20 
21     address MyETHWallet;
22     function SWAP() public {  
23         MyETHWallet = msg.sender;
24         name="SWAP";
25         symbol="SWAP";
26     }
27 
28     modifier onlyValidAddress(address _to){
29         require(_to != address(0x00));
30         _;
31     }
32     mapping (address => uint256) balances; 
33     mapping (address => mapping (address => uint256)) public allowance; //phu cap
34 
35     function setPrice(uint256 _price) public returns (uint256){
36         price = _price;
37         return price;
38     }
39 
40     function setDecimals(uint256 _decimals) public returns (uint256){
41         decimals = _decimals;
42         return decimals;
43     }
44     
45     function balanceOf(address _owner) view public returns(uint256){
46         return balances[_owner];
47     }
48     
49     //tạo ra một sự kiện công khai trên blockchain sẽ thông báo cho khách hàng
50     event Transfer(address indexed from, address indexed to, uint256 value);
51     event Withdraw(address to, uint amount); //rut tien
52 
53     function _transfer(address _from, address _to, uint _value) internal {
54         require(_to != 0x0);
55         require(balances[_from] >= _value);
56         require(balances[_to] + _value >= balances[_to]);
57         
58         uint previousBalances = balances[_from] + balances[_to];
59         
60         balances[_from] -= _value;
61         balances[_to] += _value;
62         emit Transfer(_from, _to, _value);
63         
64         assert(balances[_from] + balances[_to] == previousBalances);
65     }
66 
67     function transfer(address _to, uint256 _value) public {
68         _transfer(msg.sender, _to, _value);
69     }
70 
71     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
72         require(_value <= allowance[_from][msg.sender]);  
73         allowance[_from][msg.sender] -= _value;
74         _transfer(_from, _to, _value);
75         return true;
76     }
77 
78     function approve(address _spender, uint256 _value) public
79         returns (bool success) {
80         allowance[msg.sender][_spender] = _value;
81         return true;
82     }
83    
84     function () public payable {
85         uint256 token = (msg.value*price)/10**decimals; //1 eth = 10^18 wei
86         totalSupply += token;
87         balances[msg.sender] = token;
88     }
89     
90     
91     modifier onlyMyETHWallet(){
92         require(msg.sender == MyETHWallet);
93         _;
94     }
95     
96     function withdrawEtherOnlyOwner() external onlyMyETHWallet{
97         msg.sender.transfer(address(this).balance);
98         emit Withdraw(msg.sender,address(this).balance);
99     }
100 
101     function sendEthToAddress(address _address, uint256 _value) external onlyValidAddress(_address){
102         _address.transfer(_value);
103         emit Withdraw(_address,_value);
104     }
105 }