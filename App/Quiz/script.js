let currentQuestions = [];
let currentQuestionIndex = 0;
let score = { correct: 0, wrong: 0 };
let mode = 'normal';
let selectedCategory = '';
let questions = {};
let answeredQuestions = [];
let timeToNextQuestion = 1000;

// Fungsi sederhana untuk mengacak array
function shuffleQuestions(array) {
    return array.sort(() => Math.random() - 0.5);
}

document.addEventListener('DOMContentLoaded', async () => {
    const categorySelect = document.getElementById('category-select');
    const response = await fetch('questions.json');
    questions = await response.json();
    document.addEventListener('keydown', handleKeyPress);
    
    // Load categories
    for(const category in questions) {
        const option = document.createElement('option');
        option.value = category;
        option.textContent = category;
        categorySelect.appendChild(option);
    }
    
    // Event Listeners
    document.getElementById('start-btn').addEventListener('click', startQuiz);
    document.getElementById('prev-btn').addEventListener('click', () => navigate(-1));
    document.getElementById('next-btn').addEventListener('click', () => navigate(1));
    document.getElementById('submit-btn').addEventListener('click', submitAnswer);
    document.getElementById('restart-btn').addEventListener('click', restartQuiz);
    document.getElementById('home-btn').addEventListener('click', goToHome);
    document.getElementById('home-btn-2').addEventListener('click', goToHome);
    document.getElementById('restart-quiz-btn').addEventListener('click', restartCurrentQuiz);
    
    // Enter key submission
    document.getElementById('answer-input').addEventListener('keypress', (e) => {
        if (e.key === 'Enter') {
            submitAnswer();
        }
    });
});

function startQuiz() {
    const categories = document.getElementById('category-select').value;
    mode = document.querySelector('input[name="mode"]:checked').value;
    selectedCategory = categories;
    
    // Ambil pertanyaan dan ACAK dengan fungsi shuffle
    currentQuestions = shuffleQuestions([...questions[categories]]); // <-- BARIS INI YANG DITAMBAH
    
    if(mode === 'reversed') {
        currentQuestions = currentQuestions.map(q => ({ q: q.a, a: q.q }));
    }
    
    // Reset state
    score = { correct: 0, wrong: 0 };
    currentQuestionIndex = 0;
    answeredQuestions = Array(currentQuestions.length).fill(null);
    
    // Show category
    document.getElementById('current-category').querySelector('span').textContent = categories;
    
    // Show quiz screen
    document.getElementById('start-screen').classList.add('hidden');
    document.getElementById('quiz-screen').classList.remove('hidden');
    document.getElementById('score-screen').classList.add('hidden');
    
    renderQuestionNumbers();
    showQuestion();
}

function renderQuestionNumbers() {
    const container = document.querySelector('.question-list');
    container.innerHTML = '';
    
    currentQuestions.forEach((_, index) => {
        const numberBtn = document.createElement('button');
        numberBtn.className = 'question-number';
        numberBtn.textContent = index + 1;
        
        // Set answer status
        if (answeredQuestions[index] === true) {
            numberBtn.classList.add('correct');
        } else if (answeredQuestions[index] === false) {
            numberBtn.classList.add('wrong');
        }
        
        numberBtn.addEventListener('click', () => jumpToQuestion(index));
        container.appendChild(numberBtn);
    });
}

function showQuestion() {
    const question = currentQuestions[currentQuestionIndex];
    document.getElementById('question-text').textContent = question.q;
    const answerInput = document.getElementById('answer-input');
    answerInput.value = '';
    
    // Enable/disable input based on answer status
    answerInput.disabled = answeredQuestions[currentQuestionIndex] !== null;
    if (!answerInput.disabled) {
        answerInput.focus();
    }
    
    // Update active number
    document.querySelectorAll('.question-number').forEach((btn, index) => {
        btn.classList.toggle('active', index === currentQuestionIndex);
    });
}

function navigate(direction) {
    let newIndex = currentQuestionIndex + direction;
    
    // Wrap around if needed
    if (newIndex < 0) newIndex = currentQuestions.length - 1;
    if (newIndex >= currentQuestions.length) newIndex = 0;
    
    currentQuestionIndex = newIndex;
    showQuestion();
}

function handleKeyPress(e) {
    // Hanya tangani jika berada di layar quiz
    if (document.getElementById('quiz-screen').classList.contains('hidden')) {
        return;
    }

        switch(e.key) {
            case 'ArrowLeft':
                navigate(-1);
                break;
        case 'ArrowRight':
            navigate(1);
            break;
    }
}

function jumpToQuestion(index) {
    currentQuestionIndex = index;
    showQuestion();
}

function submitAnswer() {
    // If question already answered, return
    if (answeredQuestions[currentQuestionIndex] !== null) {
        return;
    }

    const userAnswer = document.getElementById('answer-input').value.trim().toLowerCase();
    const correctAnswer = currentQuestions[currentQuestionIndex].a.toLowerCase();
    
    // Fungsi untuk menghapus semua simbol dari string
    const removeSymbols = (str) => str.replace(/[^a-zA-Z0-9]/g, '');
    
    // Bandingkan jawaban setelah menghapus simbol
    const normalizedUserAnswer = removeSymbols(userAnswer);
    const normalizedCorrectAnswer = removeSymbols(correctAnswer);
    
    const isCorrect = normalizedUserAnswer === normalizedCorrectAnswer;
    
    // Show notification
    const notification = document.getElementById('notification');
    notification.textContent = isCorrect ? 'Correct' : 'Wrong';
    notification.className = `notification ${isCorrect ? 'correct' : 'wrong'}`;
    notification.classList.remove('hide');
    
    // Hide notification after 3 seconds
    setTimeout(() => {
        notification.classList.add('hide');
    }, timeToNextQuestion);
    
    // Update score
    if (isCorrect) {
        score.correct++;
    } else {
        score.wrong++;
    }
    
    // Mark question as answered
    answeredQuestions[currentQuestionIndex] = isCorrect;
    
    // Disable input
    document.getElementById('answer-input').disabled = true;
    
    // Update question number display
    const numberBtns = document.querySelectorAll('.question-number');
    numberBtns[currentQuestionIndex].classList.remove('correct', 'wrong');
    numberBtns[currentQuestionIndex].classList.add(isCorrect ? 'correct' : 'wrong');
    
    // Check if all questions answered
    const allAnswered = answeredQuestions.every(item => item !== null);
    if (allAnswered) {
        setTimeout(showResult, 500);
    } else {
        // Auto navigate to next unanswered question
        setTimeout(() => navigateToNextUnanswered(), timeToNextQuestion);
    }
}

function navigateToNextUnanswered() {
    let nextIndex = currentQuestionIndex;
    do {
        nextIndex = (nextIndex + 1) % currentQuestions.length;
        if (nextIndex === currentQuestionIndex) break; // All questions answered
    } while (answeredQuestions[nextIndex] !== null);
    
    if (answeredQuestions[nextIndex] === null) {
        currentQuestionIndex = nextIndex;
        showQuestion();
    }
}

function showResult() {
    document.getElementById('quiz-screen').classList.add('hidden');
    document.getElementById('score-screen').classList.remove('hidden');
    
    const accuracy = (score.correct / currentQuestions.length * 100).toFixed(2);
    document.getElementById('score-result').innerHTML = `
        <p>Correct Answers: ${score.correct}</p>
        <p>Wrong Answers: ${score.wrong}</p>
        <p>Total Questions: ${currentQuestions.length}</p>
        <p>Accuration: ${accuracy}%</p>
    `;
}

function restartQuiz() {
    document.getElementById('score-screen').classList.add('hidden');
    document.getElementById('start-screen').classList.remove('hidden');
}

function restartCurrentQuiz() {
    startQuiz();
}

function goToHome() {
    document.getElementById('quiz-screen').classList.add('hidden');
    document.getElementById('score-screen').classList.add('hidden');
    document.getElementById('start-screen').classList.remove('hidden');
}