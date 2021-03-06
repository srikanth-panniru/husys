class RandomQuestionGenerator

  def self.generate_questions(course)
    selected_qtns = []
    selected_descriptive_qtns = []
    total_radio_questions = course.questions.count
    total_descriptive = course.descriptive_questions.count

    (1..course.no_of_radio_questions).each do |no|
      random_no = Random.rand(1..total_radio_questions)
      while include_question?(random_no, selected_qtns) do
        random_no = Random.rand(1..total_radio_questions)
      end
      question = load_question(random_no)
      selected_qtns << ActiveQuestion.new(:question_id => question.id, :active_question_no => no, :description => question.description, :option_1 => question.option_1, :option_2 => question.option_2, :option_3 => question.option_3, :option_4 => question.option_4, :is_descriptive => false)
    end

    (course.no_of_radio_questions+1..course.no_of_questions).each do |no|
      random_no = Random.rand(1..total_descriptive)
      while include_question?(random_no, selected_descriptive_qtns) do
        random_no = Random.rand(1..total_descriptive)
      end
      question = load_descriptive_question(random_no)
      selected_descriptive_qtns << ActiveQuestion.new(:question_id => question.id, :active_question_no => no, :description => question.description, :is_descriptive => true)
    end

    selected_qtns.concat(selected_descriptive_qtns).shuffle.each_with_index { |qtn, index| qtn.active_question_no = index+1 }
  end

  def self.load_question(random_no)
    question = nil
    begin
      question = Question.find(random_no)
    rescue ActiveRecord::RecordNotFound
      question = load_question(random_no+1)
    end
    question
  end

  def self.load_descriptive_question(random_no)
    question = nil
    begin
      question = DescriptiveQuestion.find(random_no)
    rescue ActiveRecord::RecordNotFound
      question = load_descriptive_question(random_no+1)
    end
    question
  end

  def self.next_question(params, selected_questions)
    prev_qtn = nil
    question = nil
    if params[:active_question_no].present?
      selected_questions.each do |qtn|
        if qtn.active_question_no.to_s == params[:active_question_no]
          prev_qtn = qtn
          break
        end
      end
      prev_qtn.answer_caught = params[:answer_caught] if params[:answer_caught].present?
    end
    if params[:action_for] == "prev"
      question = prev_qtn.active_question_no ==1 ? prev_qtn : selected_questions[selected_questions.index(prev_qtn)-1]
    elsif params[:action_for] == "next"
      if (prev_qtn.present? and selected_questions[selected_questions.index(prev_qtn)+1] == selected_questions.length)
        question = nil
      else
        question = selected_questions[selected_questions.index(prev_qtn)+1]
      end
    elsif params[:action_for] == "submit"
      question = nil
    else
      question = prev_qtn.nil? ? selected_questions[0] : selected_questions[selected_questions.index(prev_qtn)]
    end
    question
  end

  private

  def self.include_question?(active_id, questions)
    matched_questions = questions.select {|question| question.question_id == active_id}
    matched_questions.length > 0
  end

  class ActiveQuestion
    include Virtus.model
    attribute :question_id, Integer
    attribute :answer_caught
    attribute :active_question_no, Integer
    attribute :description
    attribute :option_1
    attribute :option_2
    attribute :option_3
    attribute :option_4
    attribute :is_descriptive

    def descriptive?
      is_descriptive
    end
  end
end
