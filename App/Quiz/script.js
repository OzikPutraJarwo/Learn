let currentQuestions = [];
let currentQuestionIndex = 0;
let score = { correct: 0, wrong: 0 };
let mode = 'normal';
let selectedCategory = '';
let questions = {}

document.addEventListener('DOMContentLoaded', async () => {
    const categorySelect = document.getElementById('category-select');
    const response = await fetch('questions.json');
    questions = await response.json(); // Perbaikan di sini (ganti 'data' -> 'questions')
    
    // Isi kategori
    for(const category in questions) { // Ganti 'data' -> 'questions'
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
});

function startQuiz() {
    const categories = document.getElementById('category-select').value;
    mode = document.querySelector('input[name="mode"]:checked').value;
    selectedCategory = categories;
    
    // Ambil pertanyaan dan acak jika perlu
    currentQuestions = [...questions[categories]];
    if(mode === 'reversed') {
        currentQuestions = currentQuestions.map(q => ({ q: q.a, a: q.q }));
    }
    
    // Reset state
    score = { correct: 0, wrong: 0 };
    currentQuestionIndex = 0;
    
    // Tampilkan quiz screen
    document.getElementById('start-screen').classList.add('hidden');
    document.getElementById('quiz-screen').classList.remove('hidden');
    
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
        numberBtn.addEventListener('click', () => jumpToQuestion(index));
        container.appendChild(numberBtn);
    });
}

function showQuestion() {
    const question = currentQuestions[currentQuestionIndex];
    document.getElementById('question-text').textContent = question.q;
    document.getElementById('answer-input').value = '';
    
    // Update nomor aktif
    document.querySelectorAll('.question-number').forEach((btn, index) => {
        btn.classList.toggle('active', index === currentQuestionIndex);
    });
}

function navigate(direction) {
    currentQuestionIndex += direction;
    if(currentQuestionIndex < 0) currentQuestionIndex = 0;
    if(currentQuestionIndex >= currentQuestions.length) currentQuestionIndex = currentQuestions.length - 1;
    showQuestion();
}

function jumpToQuestion(index) {
    currentQuestionIndex = index;
    showQuestion();
}

function submitAnswer() {
    const userAnswer = document.getElementById('answer-input').value.trim().toLowerCase();
    const correctAnswer = currentQuestions[currentQuestionIndex].a.toLowerCase();
    
    const isCorrect = userAnswer === correctAnswer;
    if(isCorrect) {
        score.correct++;
    } else {
        score.wrong++;
    }
    
    // Tandai nomor yang sudah dijawab
    const numberBtns = document.querySelectorAll('.question-number');
    numberBtns[currentQuestionIndex].classList.add('answered');
    numberBtns[currentQuestionIndex].style.backgroundColor = isCorrect ? '#4CAF50' : '#ff4444';
    
    // Otomatis lanjut ke pertanyaan berikutnya
    if(currentQuestionIndex < currentQuestions.length - 1) {
        navigate(1);
    } else {
        showResult();
    }
}

function showResult() {
    document.getElementById('quiz-screen').classList.add('hidden');
    document.getElementById('score-screen').classList.remove('hidden');
    
    const accuracy = (score.correct / currentQuestions.length * 100).toFixed(2);
    document.getElementById('score-result').innerHTML = `
        <p>Benar: ${score.correct}</p>
        <p>Salah: ${score.wrong}</p>
        <p>Akurasi: ${accuracy}%</p>
    `;
}

function restartQuiz() {
    document.getElementById('score-screen').classList.add('hidden');
    document.getElementById('start-screen').classList.remove('hidden');
}