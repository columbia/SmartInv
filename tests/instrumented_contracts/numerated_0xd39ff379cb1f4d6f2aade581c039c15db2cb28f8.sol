1 pragma solidity ^0.4.24;
2 
3 contract BackMeApp {
4   address public owner;
5   uint256 public minEsteemAmount;
6   bool public isShutDown;
7 
8   struct EtherBox {
9     bytes32 label;
10     address owner;
11     uint256 expiration;
12     string ownerUrl;
13   }
14 
15   mapping (address => bytes32) public nicknames;
16   mapping (address => address[]) public ownerToEtherBoxes;
17   mapping (address => EtherBox) public etherBoxes;
18   mapping (address => uint256) etherBoxesNonce;
19 
20   event NewEsteem(address indexed senderAddress, bytes32 senderNickname, address indexed etherBoxAddress, bytes32 etherBoxLabel, string message, uint amount, uint256 timestamp);
21   event EtherBoxPublished(address indexed senderAddress, bytes32 senderNickname, address indexed etherBoxAddress, bytes32 etherBoxLabel, uint256 timestamp);
22   event EtherBoxDeleted(address indexed senderAddress, bytes32 senderNickname, address indexed etherBoxAddress, uint256 timestamp);
23   modifier onlyOwner() { require(msg.sender == owner); _; }
24   modifier onlyWhenRunning() { require(isShutDown == false); _; }
25 
26   constructor() public { owner = msg.sender; minEsteemAmount = 1 finney; }
27 
28   function getEtherBoxes(address _owner) external view returns(address[]) { return ownerToEtherBoxes[_owner]; }
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
44       address etherBoxAddress = address(keccak256(abi.encodePacked(msg.sender, etherBoxesNonce[msg.sender]++, now)));
45       ownerToEtherBoxes[msg.sender].push(etherBoxAddress);
46       etherBoxes[etherBoxAddress] = EtherBox({ label: _label, owner: msg.sender, ownerUrl: _ownerUrl, expiration: now+_lifespan });
47       emit EtherBoxPublished(msg.sender, nicknames[msg.sender], etherBoxAddress, _label, now);
48       if(msg.value > 0){ owner.transfer(msg.value); }
49   }
50 
51   function deleteEtherBox(address _etherBoxAddress) external {
52     require(etherBoxes[_etherBoxAddress].owner == msg.sender);
53     require(etherBoxes[_etherBoxAddress].expiration <= now);
54     address[] storage ownedEtherBoxes = ownerToEtherBoxes[msg.sender];
55     address[] memory tempEtherBoxes = ownedEtherBoxes;
56     uint newLength = 0;
57     for(uint i = 0; i < tempEtherBoxes.length; i++){
58       if(tempEtherBoxes[i] != _etherBoxAddress){
59         ownedEtherBoxes[newLength] = tempEtherBoxes[i];
60         newLength++;
61       }
62     }
63     ownedEtherBoxes.length = newLength;
64     delete etherBoxes[_etherBoxAddress];
65     emit EtherBoxDeleted(msg.sender, nicknames[msg.sender], _etherBoxAddress, now);
66   }
67 
68   function setMinEsteemAmount(uint256 _amount) external onlyOwner() { minEsteemAmount = _amount; }
69   function toggleFactoryPower() external onlyOwner() { isShutDown = isShutDown == false ? true : false; }
70   function destroyFactory() external onlyOwner() { selfdestruct(owner); }
71 }