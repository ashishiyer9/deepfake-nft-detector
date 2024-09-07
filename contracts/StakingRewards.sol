// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StakingRewards is Ownable {
    IERC20 public stakingToken; // Token to be staked
    IERC20 public rewardsToken; // Token used as rewards

    uint256 public rewardRate; // Reward rate per block (or per second, as needed)
    uint256 public totalStaked; // Total amount of tokens staked
    mapping(address => uint256) public stakedBalances; // User's staked balance
    mapping(address => uint256) public rewardDebt; // Reward debt tracking

    uint256 public lastUpdateTime;
    uint256 public rewardPerTokenStored;
    mapping(address => uint256) public rewards;

    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);

    constructor(
        address initialOwner,
        address _stakingToken,
        address _rewardsToken,
        uint256 _rewardRate
    ) Ownable(initialOwner) {
        stakingToken = IERC20(_stakingToken);
        rewardsToken = IERC20(_rewardsToken);
        rewardRate = _rewardRate;
    }

    // Modifier to update rewards before state changes
    modifier updateReward(address account) {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = block.timestamp;

        if (account != address(0)) {
            rewards[account] = earned(account);
            rewardDebt[account] = rewardPerTokenStored;
        }
        _;
    }

    // Stake tokens to earn rewards
    function stake(uint256 amount) external updateReward(msg.sender) {
        require(amount > 0, "Cannot stake 0 tokens");

        totalStaked += amount;
        stakedBalances[msg.sender] += amount;

        stakingToken.transferFrom(msg.sender, address(this), amount);
        emit Staked(msg.sender, amount);
    }

    // Withdraw staked tokens
    function withdraw(uint256 amount) external updateReward(msg.sender) {
        require(amount > 0, "Cannot withdraw 0 tokens");
        require(
            stakedBalances[msg.sender] >= amount,
            "Insufficient staked balance"
        );

        totalStaked -= amount;
        stakedBalances[msg.sender] -= amount;

        stakingToken.transfer(msg.sender, amount);
        emit Withdrawn(msg.sender, amount);
    }

    // Claim rewards
    function claimReward() external updateReward(msg.sender) {
        uint256 reward = rewards[msg.sender];
        require(reward > 0, "No rewards available");

        rewards[msg.sender] = 0;
        rewardsToken.transfer(msg.sender, reward);
        emit RewardPaid(msg.sender, reward);
    }

    // Calculate how much reward per staked token
    function rewardPerToken() public view returns (uint256) {
        if (totalStaked == 0) {
            return rewardPerTokenStored;
        }
        return
            rewardPerTokenStored +
            (((block.timestamp - lastUpdateTime) * rewardRate * 1e18) /
                totalStaked);
    }

    // Calculate earned rewards for a user
    function earned(address account) public view returns (uint256) {
        return
            ((stakedBalances[account] *
                (rewardPerToken() - rewardDebt[account])) / 1e18) +
            rewards[account];
    }

    // Allow the owner to change the reward rate
    function setRewardRate(uint256 newRate) external onlyOwner {
        rewardRate = newRate;
    }

    // Emergency withdrawal of staking tokens (without rewards)
    function emergencyWithdraw() external {
        uint256 stakedAmount = stakedBalances[msg.sender];
        require(stakedAmount > 0, "No staked tokens to withdraw");

        totalStaked -= stakedAmount;
        stakedBalances[msg.sender] = 0;

        stakingToken.transfer(msg.sender, stakedAmount);
        emit Withdrawn(msg.sender, stakedAmount);
    }

    // Fund the contract with rewards tokens for future rewards distribution
    function fundRewardPool(uint256 amount) external onlyOwner {
        rewardsToken.transferFrom(msg.sender, address(this), amount);
    }
}
