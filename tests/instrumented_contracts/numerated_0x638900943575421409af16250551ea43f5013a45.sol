1 interface tokenRecipient { function receiveApproval(address from, uint256 value, address token, bytes extraData) public; }
2 
3 contract CoinDump {
4     mapping (address => uint256) public balanceOf;
5     
6     string public name = 'CoinDump';
7     string public symbol = 'CD';
8     uint8 public decimals = 6;
9     
10     function transfer(address _to, uint256 _value) public {
11         balanceOf[msg.sender] -= _value;
12         balanceOf[_to] += _value;
13     }
14     
15     function CoinDump() public {
16         balanceOf[msg.sender] = 1000000000000000;                   // Amount of decimals for display purposes
17     }
18     
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 }