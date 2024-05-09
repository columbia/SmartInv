pragma solidity ^0.5.0;
import "./SafeMath.sol";
import "./Libraries/IERC20.sol";
//import "./Libraries/Lib.sol";
import "./Libraries/VeriSolContracts.sol";


contract TimelockController is IERC20 {
    
    struct Proposal {
          uint256 sTime; 
          uint256 voteValue; 
          address newOwner; 
          }
     address owner;
     IERC20 votingToken;
     address[] votedProposals;
     Proposal proposal;
    
    function votedProposal(address voter) internal {        
        votedProposals.push(voter);
        return votedProposals;    
        }
   
    function getAllProposals() internal {        
        return votedProposals;    
        }

    function findHighest(address[] votedProposals) internal {
        address highestProposal;
        uint256 highestAmount;
         highestAmount = 0;
        for (uint i=0; i<votedProposals.length; i++) {
            if (votingToken.balanceOf(votedProposals[i])) >  highestAmount) {
                highestAmount = votingToken.balanceOf(votedProposals[i])); 
                highestProposal = votedProposals[i];
            }    
        }
        return highestProposal;
        }

    function startExecute() external {
              require(proposal.sTime == 0,"on-going proposal");
              proposal = Proposal(block.timestamp, msg.sender);
        }

    function execute(uint amount) external {
              require(proposal.sTime + 24 > block.timestamp, "execution has ended");
              votingToken.transferFrom(msg.sender, address(this), amount); 
              votedProposal(msg.sender);    
        }
    function endExecute() external {
              require(proposal.sTime != 0, "no proposal");
              require(proposal.sTime + 24 < block.timestamp, "execution has not ended");
              require(votingToken.balanceOf(address(this))*2 > votingToken.totalSupply(), "execution failed");
              //SmartInv inferred: 
              //assert(VeriSol.Old(votingToken.balanceOf(address(this))) == votingToken.balanceOf(address(this)));
              owner = findHighest(getAllProposals());
              delete proposal;
        }
    function rewardFunds() public view returns (uint256) {
        return lockedFunds;
    }

}