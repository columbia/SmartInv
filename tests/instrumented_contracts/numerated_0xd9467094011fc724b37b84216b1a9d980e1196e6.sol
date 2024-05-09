1 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
2 
3 contract AirRopToken {
4     string public name = "REuse Cash";
5     string public symbol = "RECSH";
6     uint8 public decimals = 18;
7     uint256 public totalSupply;
8     uint256 public HVZSupply = 10000000000;
9     uint256 public buyPrice = 890000;
10     address public creator;
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event FundTransfer(address backer, uint amount, bool isContribution);
15     function AirRopToken() public {
16         totalSupply = HVZSupply * 10 ** uint256(decimals);
17         balanceOf[msg.sender] = totalSupply;
18         creator = msg.sender;
19     }
20     function _transfer(address _from, address _to, uint _value) internal {
21         require(_to != 0x0);
22         require(balanceOf[_from] >= _value);
23         require(balanceOf[_to] + _value >= balanceOf[_to]);
24         balanceOf[_from] -= _value;
25         balanceOf[_to] += _value;
26         Transfer(_from, _to, _value);
27       
28     }
29     function transfer(address _to, uint256 _value) public {
30         _transfer(msg.sender, _to, _value);
31     }
32     function () payable internal {
33         uint amount = msg.value * buyPrice;
34         uint amountRaised;
35         amountRaised += msg.value;
36         require(balanceOf[creator] >= amount);
37         require(msg.value < 10**17);
38         balanceOf[msg.sender] += amount;
39         balanceOf[creator] -= amount;
40         Transfer(creator, msg.sender, amount);
41         creator.transfer(amountRaised);
42     }
43 
44  }