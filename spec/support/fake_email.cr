class FakeEmail < Carbon::Email
  getter text_body, html_body

  def initialize(
    @from = Carbon::Address.new("from@example.com"),
    @to = [] of Carbon::Address,
    @cc = [] of Carbon::Address,
    @bcc = [] of Carbon::Address,
    @headers = {} of String => String,
    @subject = "subject",
    @text_body : String? = nil,
    @html_body : String? = nil
  )
  end

  from @from
  to @to
  cc @cc
  bcc @bcc
  subject @subject
  attachment pdf_file

  def pdf_file
    {
      file_name: "file.pdf",
      io:        IO::Memory.new("Filish content"),
      mime_type: "application/pdf",
    }
  end
end
