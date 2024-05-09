pragma solidity ^0.5.0;
import "./SafeMath.sol";
import "./Libraries/IERC20.sol";
//import "./Libraries/Lib.sol";
import "./Libraries/VeriSolContracts.sol";


contract TimelockController is IERC20 {
    
    struct Proposal {
          uint256 sTime; address newOwner;
          }
     address owner;
     IERC20 votingToken;
     uint256 lockedFunds;
     Proposal proposal;
     

    function startExecute() external {
              require(proposal.sTime == 0,"on-going proposal");
              proposal = Proposal(block.timestamp, msg.sender);
          }

    function execute(uint amount) external {
              require(proposal.sTime + 24 > block.timestamp, "execution has ended");
              votingToken.transferFrom(msg.sender, address(this), amount); 
              lockedFunds += amount;         
         }
    function endExecute() external {
              require(proposal.sTime != 0, "no proposal");
              require(proposal.sTime + 24 < block.timestamp, "execution has not ended");
              require(votingToken.balanceOf(address(this))*2 > votingToken.totalSupply(), "execution failed");
              //SmartInv inferred: 
              assert(VeriSol.Old(votingToken.balanceOf(address(this))) == votingToken.balanceOf(address(this)));
              owner = proposal.newOwner;
              delete proposal;
          }
    function rewardFunds() public view returns (uint256) {
        return lockedFunds;
    }
}