export class TagModel {
  tagName: string
  nameColor: string
  borderColor: string
}

export class QuestionTypeModel {
  public id: number
  public name: string
  public icon?: string
  public describeInfo?: string
  public displayNewestFlag?: 0 | 1
  public tags?: TagModel[]
}