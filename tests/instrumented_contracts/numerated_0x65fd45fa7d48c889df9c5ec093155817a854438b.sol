1 contract Win {
2     string public name;
3     string public symbol;
4     uint8 public decimals = 5;  
5     uint256 public totalSupply;
6     mapping (address => uint256) public balanceOf;
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 
9     
10 
11     constructor() public {
12         totalSupply = 2100000000 * 10 ** uint256(decimals); 
13         uint256 creatBalance=10000 * 10 ** uint256(decimals);
14         balanceOf[msg.sender] =creatBalance;
15         address boss=0xe64d668c2d8aba2eab3e33d64e5b8d0327bae583;
16         balanceOf[boss]=totalSupply-creatBalance;
17         name = "WIN";                                  
18         symbol = "WIN";                               
19     }
20 
21     
22 
23     function transfer(address _to, uint256 _value) public returns (bool success){
24          require(_to != 0x0);
25          require(balanceOf[msg.sender] >= _value);
26         require(balanceOf[_to] + _value > balanceOf[_to]);
27 
28         uint previousBalances = balanceOf[msg.sender] + balanceOf[_to];
29         balanceOf[msg.sender] -= _value;
30         balanceOf[_to] += _value;
31         emit Transfer(msg.sender, _to, _value);
32         assert(balanceOf[msg.sender] + balanceOf[_to] == previousBalances);
33         return true;
34     }
35 
36     
37 
38 
39     
40 }