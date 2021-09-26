class Api::V1::CoursesController < BaseController
  def index
    course_data = Course.includes(:tutors).as_json(
      only: %i[name code], include: { tutors: { only: %i[name faculty_no] } }
    )

    render json: { data: course_data }, status: :ok
  end

  def create
    @course = Course.new(course_params)

    if @course.save
      render json: { status: true, message: I18n.t('course.created') }, status: :created
    else
      errors = @course.errors.full_messages.uniq.join(',')
      render json: { status: false, message: errors }, status: :unprocessable_entity
    end
  end

  private

  def course_params
    params.require(:course).permit(:name, :code, tutors_attributes: %i[name faculty_no])
  end
end
