1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract TaskCoin {
6     string public name = 'TaskCoin';
7     string public symbol = 'TC';
8     uint8 public decimals = 18;
9     uint256 public totalSupply = 100000000 * 10 ** uint256(decimals);
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
16     
17     function TaskCoin() public {
18         balanceOf[msg.sender] = totalSupply;
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
43     function approve(address _spender, uint256 _value) public returns (bool success) {
44         require(_value == 0 || allowance[msg.sender][_spender] == 0);
45         allowance[msg.sender][_spender] = _value;
46         Approval(msg.sender, _spender, _value);
47         return true;
48     }
49 
50 }