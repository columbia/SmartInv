1 pragma solidity ^0.8.0;
2 
3 import "./FeiTimedMinter.sol";
4 import "@openzeppelin/contracts/access/Ownable.sol";
5 
6 /// @title OwnableTimedMinter
7 /// @notice A FeiTimedMinter that mints only when called by an owner
8 contract OwnableTimedMinter is FeiTimedMinter, Ownable {
9     /**
10         @notice constructor for OwnableTimedMinter
11         @param _core the Core address to reference
12         @param _owner the minter and target to receive minted FEI
13         @param _frequency the frequency buybacks happen
14         @param _initialMintAmount the initial FEI amount to mint
15     */
16     constructor(
17         address _core,
18         address _owner,
19         uint256 _frequency,
20         uint256 _initialMintAmount
21     ) FeiTimedMinter(_core, _owner, 0, _frequency, _initialMintAmount) {
22         transferOwnership(_owner);
23     }
24 
25     /// @notice triggers a minting of FEI by owner
26     function mint() public override onlyOwner {
27         super.mint();
28     }
29 }
