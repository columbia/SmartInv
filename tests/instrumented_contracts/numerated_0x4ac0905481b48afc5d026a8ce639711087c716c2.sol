1 pragma solidity ^0.4.22;
2 
3 contract BackMeApp {
4   address public owner;
5   bool public isShutDown;
6   uint256 public minEsteemAmount;
7 
8   struct EtherBox {
9     bytes32 label;
10     address owner;
11     string ownerUrl;
12     uint256 expiration;
13   }
14 
15   mapping (address => bytes32) public nicknames;
16   mapping (address => address[]) public ownerToEtherBoxes;
17   mapping (address => EtherBox) public etherBoxes;
18 
19   event NewEsteem(address indexed senderAddress, bytes32 senderNickname, address indexed etherBoxAddress, bytes32 etherBoxLabel, string message, uint amount, uint256 timestamp);
20   event EtherBoxPublished(address indexed senderAddress, bytes32 senderNickname, address indexed etherBoxAddress, bytes32 etherBoxLabel, uint256 timestamp);
21   event EtherBoxDeleted(address indexed senderAddress, bytes32 senderNickname, address indexed etherBoxAddress, uint256 timestamp);
22   modifier onlyOwner() { require(msg.sender == owner); _; }
23   modifier onlyWhenRunning() { require(isShutDown == false); _; }
24 
25   constructor() public { owner = msg.sender; minEsteemAmount = 1 finney; }
26   function() public payable {}
27 
28   function getEtherBoxes(address _owner) external view returns (address[]) { return ownerToEtherBoxes[_owner]; }
29   function isExpired(address _etherBoxAddress) external view returns(bool) { return etherBoxes[_etherBoxAddress].expiration <= now ? true : false; }
30 
31   function esteem(bytes32 _nickname, string _message, address _to) external payable {
32     assert(bytes(_message).length <= 300);
33     EtherBox storage etherBox = etherBoxes[_to];
34     require(etherBox.expiration > now);
35     assert(etherBox.owner != address(0));
36     nicknames[msg.sender] = _nickname;
37     emit NewEsteem(msg.sender, _nickname, _to, etherBox.label, _message, msg.value, now);
38     etherBox.owner.transfer(msg.value);
39   }
40 
41   function publishEtherBox (bytes32 _label, string _ownerUrl, uint _lifespan) external onlyWhenRunning() payable {
42       require(ownerToEtherBoxes[msg.sender].length < 10);
43       assert(bytes(_ownerUrl).length <= 200);
44       address etherBoxAddress = address(keccak256(msg.sender, now));
45       ownerToEtherBoxes[msg.sender].push(etherBoxAddress);
46       etherBoxes[etherBoxAddress] = EtherBox({
47         label: _label,
48         owner: msg.sender,
49         ownerUrl: _ownerUrl,
50         expiration: now + _lifespan
51       });
52       emit EtherBoxPublished(msg.sender, nicknames[msg.sender], etherBoxAddress, _label, now);
53       if(msg.value > 0){ owner.transfer(msg.value); }
54   }
55 
56   function deleteEtherBox(address _etherBoxAddress) external {
57     require(etherBoxes[_etherBoxAddress].owner == msg.sender);
58     require(etherBoxes[_etherBoxAddress].expiration <= now);
59     address[] storage ownedEtherBoxes = ownerToEtherBoxes[msg.sender];
60     address[] memory tempEtherBoxes = ownedEtherBoxes;
61     uint newLength = 0;
62     for(uint i = 0; i < tempEtherBoxes.length; i++){
63       if(tempEtherBoxes[i] != _etherBoxAddress){
64         ownedEtherBoxes[newLength] = tempEtherBoxes[i];
65         newLength++;
66       }
67     }
68     ownedEtherBoxes.length = newLength;
69     delete etherBoxes[_etherBoxAddress];
70     emit EtherBoxDeleted(msg.sender, nicknames[msg.sender], _etherBoxAddress, now);
71   }
72 
73   function getBalance() external view returns(uint) { return address(this).balance; }
74   function withdrawBalance() external onlyOwner() { owner.transfer(address(this).balance); }
75   function toggleFactoryPower() external onlyOwner() { isShutDown = isShutDown == false ? true : false; }
76   function destroyFactory() external onlyOwner() { selfdestruct(owner); }
77 }