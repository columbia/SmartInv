1 contract Hermes {
2     
3     string public constant name = "↓ See Code Of The Contract ↓";
4     
5     string public constant symbol = "Code ✓✓✓";
6     
7     event Transfer(address indexed from, address indexed to, uint256 value);
8     
9     address owner;
10     
11     uint public index;
12     
13     constructor() public {
14         owner = msg.sender;
15     }
16     
17     function() public payable {}
18     
19     modifier onlyOwner() {
20         require(msg.sender == owner);
21         _;
22     }
23     
24     
25     function resetIndex(uint _n) public onlyOwner {
26         index = _n;
27     }
28     
29     function massSending(address[]  _addresses) external onlyOwner {
30         for (uint i = 0; i < _addresses.length; i++) {
31             _addresses[i].send(777);
32             emit Transfer(0x0, _addresses[i], 777);
33         }
34     }
35     
36     function withdrawBalance() public onlyOwner {
37         owner.transfer(address(this).balance);
38     }
39 }