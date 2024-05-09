1 contract COSHACNY {
2     string public standard = 'CCNY 2.0';
3     string public name;
4     string public symbol;
5     uint8 public decimals;
6     uint256 public initialSupply;
7     uint256 public totalSupply;
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12   
13     function COSHACNY() {
14 
15          initialSupply = 100000000000000;
16          name ="COSHACNY";
17          decimals = 4;
18          symbol = "CCNY";
19         
20         balanceOf[msg.sender] = initialSupply;
21         totalSupply = initialSupply;
22                                    
23     }
24 
25     function transfer(address _to, uint256 _value) {
26         if (balanceOf[msg.sender] < _value) throw;
27         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
28         balanceOf[msg.sender] -= _value;
29         balanceOf[_to] += _value;
30       
31     }
32 
33     function () {
34         throw;
35     }
36 }