1 pragma solidity ^0.4.26;
2 
3 contract MyToken {
4     string public name;
5     string public symbol;
6     uint8 public decimals = 8;
7     uint256 internal _totalSupply;
8     mapping (address => uint256) public balanceOf;
9     mapping (address => mapping (address => uint256)) internal _allowance;
10 
11     event Transfer(address indexed from, address indexed to, uint256 value);
12 
13     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
14 
15 
16     function MyToken(uint256 initialSupply, string tokenName, string tokenSymbol) public {
17         _totalSupply = initialSupply * 10 ** uint256(decimals);
18         balanceOf[msg.sender] = totalSupply();
19         name = tokenName;
20         symbol = tokenSymbol;
21     }
22     function _transfer(address _from, address _to, uint _value) internal {
23         require(_to != 0x0);
24         require(balanceOf[_from] >= _value);
25         require(balanceOf[_to] + _value > balanceOf[_to]);
26         uint previousBalances = balanceOf[_from] + balanceOf[_to];
27         balanceOf[_from] -= _value;
28         balanceOf[_to] += _value;
29         emit Transfer(_from, _to, _value);
30         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
31     }
32     function totalSupply() view returns(uint256)
33     {
34         return _totalSupply;
35     }
36     function transfer(address _to, uint256 _value) public {
37         _transfer(msg.sender, _to, _value);
38     }
39     function allowance(address _owner, address _spender) view returns (uint256 remaining)
40     {
41         remaining = _allowance[_owner][_spender];
42     }
43     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
44         require(_value <= allowance(_from,_to));
45         _allowance[_from][_to] -= _value;
46         _transfer(_from, _to, _value);
47         return true;
48     }
49 
50     function approve(address _spender, uint256 _value) public
51     returns (bool success) {
52         _allowance[msg.sender][_spender] = _value;
53         emit Approval(msg.sender, _spender, _value);
54         return true;
55     }
56 }