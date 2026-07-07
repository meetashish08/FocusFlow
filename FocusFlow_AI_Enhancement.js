// AI Goal Parser Enhancement for FocusFlow
// This module adds AI-powered goal parsing using Portkey API

// Portkey API Configuration
const PORTKEY_CONFIG = {
    baseURL: 'https://api.portkey.ai',
    apiKey: 'MfSPscvdmxTj8jGpP34lq41axRRK',
    defaultModel: '@vertexai-global/anthropic.claude-sonnet-4-5@20250929'
};

// AI Goal Parser Functions
async function parseGoalWithAI(goalStatement) {
    const prompt = `You are a productivity expert helping users break down goals into actionable steps.

User's goal statement: "${goalStatement}"

Extract and analyze this goal:
1. Identify the main goal
2. Break it into 3-7 concrete, achievable steps
3. Suggest improvements if the goal is vague or too ambitious
4. Make steps SMART (Specific, Measurable, Achievable, Relevant, Time-bound)

Respond in JSON format:
{
    "goalName": "Clear, concise goal name",
    "steps": [
        "Step 1: Specific action",
        "Step 2: Specific action",
        ...
    ],
    "suggestions": "Brief improvement suggestion (optional)",
    "dailyTask": "One small task user can do today"
}

Be encouraging and practical. Keep steps simple and achievable.`;

    try {
        const response = await fetch(PORTKEY_CONFIG.baseURL + '/v1/chat/completions', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'x-portkey-api-key': PORTKEY_CONFIG.apiKey,
                'x-portkey-mode': 'single'
            },
            body: JSON.stringify({
                model: PORTKEY_CONFIG.defaultModel,
                messages: [
                    {
                        role: 'user',
                        content: prompt
                    }
                ],
                max_tokens: 1000,
                temperature: 0.7
            })
        });

        if (!response.ok) {
            throw new Error(`API request failed: ${response.statusText}`);
        }

        const data = await response.json();
        const content = data.choices[0].message.content;

        // Extract JSON from markdown code blocks if present
        let jsonMatch = content.match(/```json\n([\s\S]*?)\n```/);
        if (jsonMatch) {
            return JSON.parse(jsonMatch[1]);
        }

        // Try to parse as direct JSON
        return JSON.parse(content);

    } catch (error) {
        console.error('AI parsing error:', error);
        throw error;
    }
}

async function enhanceGoalWithAI(goalName, existingSteps) {
    const prompt = `You are a productivity coach helping improve a goal and its action steps.

Goal: "${goalName}"
Current steps: ${existingSteps.map((s, i) => `\n${i + 1}. ${s}`).join('')}

Provide:
1. Alternative/better steps if current ones can be improved
2. Missing important steps
3. Tips for achieving this goal faster
4. Potential obstacles and how to overcome them

Respond in JSON format:
{
    "improvedSteps": [
        "Improved or additional step 1",
        "Improved or additional step 2",
        ...
    ],
    "tips": [
        "Tip 1",
        "Tip 2",
        "Tip 3"
    ],
    "obstacles": [
        {
            "obstacle": "Potential challenge",
            "solution": "How to overcome it"
        }
    ]
}

Be specific and actionable.`;

    try {
        const response = await fetch(PORTKEY_CONFIG.baseURL + '/v1/chat/completions', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'x-portkey-api-key': PORTKEY_CONFIG.apiKey,
                'x-portkey-mode': 'single'
            },
            body: JSON.stringify({
                model: PORTKEY_CONFIG.defaultModel,
                messages: [
                    {
                        role: 'user',
                        content: prompt
                    }
                ],
                max_tokens: 1200,
                temperature: 0.7
            })
        });

        if (!response.ok) {
            throw new Error(`API request failed: ${response.statusText}`);
        }

        const data = await response.json();
        const content = data.choices[0].message.content;

        // Extract JSON from markdown code blocks if present
        let jsonMatch = content.match(/```json\n([\s\S]*?)\n```/);
        if (jsonMatch) {
            return JSON.parse(jsonMatch[1]);
        }

        return JSON.parse(content);

    } catch (error) {
        console.error('AI enhancement error:', error);
        throw error;
    }
}

// UI Functions for AI Goal Parser
function openAIGoalParser() {
    document.getElementById('aiGoalModal').classList.add('active');
    document.getElementById('aiGoalInput').value = '';
    document.getElementById('aiGoalResult').classList.add('hidden');
    document.getElementById('aiGoalLoading').classList.add('hidden');
}

async function parseGoalStatement() {
    const input = document.getElementById('aiGoalInput').value.trim();

    if (!input) {
        alert('Please enter a goal statement');
        return;
    }

    // Show loading
    document.getElementById('aiGoalLoading').classList.remove('hidden');
    document.getElementById('aiGoalResult').classList.add('hidden');

    try {
        const parsed = await parseGoalWithAI(input);

        // Display results
        document.getElementById('aiParsedGoalName').textContent = parsed.goalName;

        const stepsList = document.getElementById('aiParsedSteps');
        stepsList.innerHTML = parsed.steps.map((step, index) =>
            `<li>
                <input type="checkbox" id="ai-step-${index}" checked>
                <label for="ai-step-${index}">${step}</label>
            </li>`
        ).join('');

        if (parsed.suggestions) {
            document.getElementById('aiSuggestions').textContent = parsed.suggestions;
            document.getElementById('aiSuggestionsSection').classList.remove('hidden');
        } else {
            document.getElementById('aiSuggestionsSection').classList.add('hidden');
        }

        document.getElementById('aiDailyTask').textContent = parsed.dailyTask || parsed.steps[0];

        // Store parsed data
        window.tempParsedGoal = parsed;

        // Hide loading, show result
        document.getElementById('aiGoalLoading').classList.add('hidden');
        document.getElementById('aiGoalResult').classList.remove('hidden');

    } catch (error) {
        document.getElementById('aiGoalLoading').classList.add('hidden');
        alert('Failed to parse goal. Please try again.\n\nError: ' + error.message);
    }
}

async function enhanceCurrentGoal() {
    if (!window.tempParsedGoal) return;

    const goalName = document.getElementById('aiParsedGoalName').textContent;
    const steps = window.tempParsedGoal.steps;

    // Show loading
    document.getElementById('aiEnhanceLoading').classList.remove('hidden');

    try {
        const enhanced = await enhanceGoalWithAI(goalName, steps);

        // Show enhancement results in a modal or section
        let enhancementHTML = '<div style="background: var(--bg-card); padding: 20px; border-radius: 12px; margin-top: 20px;">';
        enhancementHTML += '<h3>✨ AI Enhancements</h3>';

        if (enhanced.improvedSteps && enhanced.improvedSteps.length > 0) {
            enhancementHTML += '<h4 style="margin-top: 15px;">Improved Steps:</h4><ul>';
            enhanced.improvedSteps.forEach(step => {
                enhancementHTML += `<li>${step}</li>`;
            });
            enhancementHTML += '</ul>';
        }

        if (enhanced.tips && enhanced.tips.length > 0) {
            enhancementHTML += '<h4 style="margin-top: 15px;">💡 Tips:</h4><ul>';
            enhanced.tips.forEach(tip => {
                enhancementHTML += `<li>${tip}</li>`;
            });
            enhancementHTML += '</ul>';
        }

        if (enhanced.obstacles && enhanced.obstacles.length > 0) {
            enhancementHTML += '<h4 style="margin-top: 15px;">⚠️ Potential Obstacles:</h4>';
            enhanced.obstacles.forEach(obs => {
                enhancementHTML += `<div style="margin: 10px 0; padding: 10px; background: var(--bg-secondary); border-radius: 8px;">
                    <strong>Challenge:</strong> ${obs.obstacle}<br>
                    <strong>Solution:</strong> ${obs.solution}
                </div>`;
            });
        }

        enhancementHTML += '</div>';

        document.getElementById('aiEnhancementResult').innerHTML = enhancementHTML;
        document.getElementById('aiEnhancementResult').classList.remove('hidden');
        document.getElementById('aiEnhanceLoading').classList.add('hidden');

    } catch (error) {
        document.getElementById('aiEnhanceLoading').classList.add('hidden');
        alert('Failed to enhance goal. Please try again.\n\nError: ' + error.message);
    }
}

function createGoalFromAI() {
    if (!window.tempParsedGoal) return;

    const goalName = document.getElementById('aiParsedGoalName').textContent;
    const dailyTask = document.getElementById('aiDailyTask').textContent;

    // Get selected steps
    const selectedSteps = [];
    window.tempParsedGoal.steps.forEach((step, index) => {
        const checkbox = document.getElementById(`ai-step-${index}`);
        if (checkbox && checkbox.checked) {
            selectedSteps.push({
                id: Date.now() + index,
                text: step,
                completed: false
            });
        }
    });

    // Create the goal
    const goal = {
        id: Date.now(),
        name: goalName,
        steps: selectedSteps,
        createdAt: new Date().toISOString()
    };

    state.goals.push(goal);
    saveData();
    renderGoals();

    // Close modal
    closeModal('aiGoalModal');

    // Ask if user wants to add daily task
    if (confirm('Goal created! 🎉\n\nAdd "' + dailyTask + '" to today\'s tasks?')) {
        addTaskFromGoal(dailyTask);
    }

    // Show success message
    celebrate();
    showRandomQuote();
}

// Add these functions to window object for global access
window.openAIGoalParser = openAIGoalParser;
window.parseGoalStatement = parseGoalStatement;
window.enhanceCurrentGoal = enhanceCurrentGoal;
window.createGoalFromAI = createGoalFromAI;
