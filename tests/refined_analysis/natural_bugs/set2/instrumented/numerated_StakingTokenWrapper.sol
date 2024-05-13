1 pragma solidity ^0.8.0;
2 
3 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
4 import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
5 import "./ITribalChief.sol";
6 
7 /// @title StakingTokenWrapper for TribalChief
8 /// @notice Allows the TribalChief to distribute TRIBE to a beneficiary contract
9 /// The beneficiary is the sole holder of a dummy token staked in the TribalChief
10 contract StakingTokenWrapper is ERC20, Initializable {
11     /// @notice the TribalChief staking rewards contract
12     ITribalChief public tribalChief;
13 
14     /// @notice the pool id of the corresponding pool in the TribalChief
15     uint256 public pid;
16 
17     /// @notice the recipient of all harvested TRIBE
18     address public beneficiary;
19 
20     /// @notice constructor for the StakingTokenWrapper
21     /// @param _tribalChief the TribalChief contract
22     /// @param _beneficiary the recipient of all harvested TRIBE
23     constructor(ITribalChief _tribalChief, address _beneficiary) ERC20("TribalChief Staking Wrapper", "TKN") {
24         tribalChief = _tribalChief;
25         beneficiary = _beneficiary;
26     }
27 
28     /// @notice initialize the pool with this token as the sole staker
29     /// @param _pid the pool id of the staking pool associated with this token
30     function init(uint256 _pid) external initializer {
31         require(address(tribalChief.stakedToken(_pid)) == address(this), "StakedTokenWrapper: invalid pid");
32         pid = _pid;
33 
34         uint256 amount = 1e18;
35         _mint(address(this), amount);
36 
37         _approve(address(this), address(tribalChief), amount);
38         tribalChief.deposit(pid, amount, 0);
39     }
40 
41     /// @notice send rewards to the beneficiary
42     function harvest() external {
43         tribalChief.harvest(pid, beneficiary);
44     }
45 }
