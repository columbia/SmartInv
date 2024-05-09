1 contract Company { 
2     /* Public variables of the token */
3     string public standart = 'Token 0.1';
4     string public name;
5     string public symbol;
6     uint8 public decimals;
7     uint256 public initilSupply;
8     uint256 public totalSupply;
9     
10     /* This creates an array with all balances */
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping(address => uint256)) public allowance;
13     
14    
15     function Company() {
16         /* if supply not given then generate 1 million of the smallest unit of the token */
17         //if (_supply == 0) _supply = 1000000;
18         
19         /* Unless you add other functions these variables will never change */
20         initilSupply = 10000000000000000;
21         name = "Company";
22         decimals = 8;   
23         symbol = "COMP";
24         
25        balanceOf[msg.sender] = initilSupply;
26        totalSupply = initilSupply;
27     }
28 
29     /* Send coins */
30     function transfer(address _to, uint256 _value) {
31       if (balanceOf[msg.sender] < _value) revert();
32       if(balanceOf[_to] + _value < balanceOf[_to]) revert();
33       balanceOf[msg.sender] -= _value;
34       balanceOf[_to] += _value;
35     }
36 }