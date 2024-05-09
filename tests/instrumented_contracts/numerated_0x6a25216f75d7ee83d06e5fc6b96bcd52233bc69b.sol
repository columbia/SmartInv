1 contract Owned {
2     address public owner;
3     address public newOwner;
4 
5    function Owned() public {
6         owner = msg.sender;
7     }
8 
9     modifier onlyOwner {
10         assert(msg.sender == owner);
11         _;
12     }
13 
14     function transferOwnership(address _newOwner) public onlyOwner {
15         require(_newOwner != owner);
16         newOwner = _newOwner;
17     }
18 
19     function acceptOwnership() public {
20         require(msg.sender == newOwner);
21         emit OwnerUpdate(owner, newOwner);
22         owner = newOwner;
23         newOwner = 0x0;
24     }
25 
26     event OwnerUpdate(address _prevOwner, address _newOwner);
27 }
28 
29 contract XaurumInterface {
30     function doMelt(uint256 _xaurAmount, uint256 _goldAmount) public returns (bool);
31     function balanceOf(address _owner) public constant returns (uint256 balance);
32 }
33 
34 contract MeltingContract is Owned{
35     address XaurumAddress;
36     uint public XaurumAmountMelted;
37     uint public GoldAmountMelted;
38     
39     event MeltDone(uint xaurAmount, uint goldAmount);
40     
41     function MeltingContract() public {
42         XaurumAddress = 0x4DF812F6064def1e5e029f1ca858777CC98D2D81;
43     }
44     
45     function doMelt(uint256 _xaurAmount, uint256 _goldAmount) public onlyOwner returns (bool) {
46         uint actualBalance = XaurumInterface(XaurumAddress).balanceOf(address(this));
47         require(actualBalance > XaurumAmountMelted);
48         require(actualBalance - XaurumAmountMelted >= _xaurAmount);
49         XaurumInterface(XaurumAddress).doMelt(_xaurAmount, _goldAmount);
50         XaurumAmountMelted += _xaurAmount;
51         GoldAmountMelted += _goldAmount;
52         MeltDone(_xaurAmount, _goldAmount);
53     }
54 }